document.addEventListener('DOMContentLoaded', () => {
    chrome.storage.local.get(['researchNotes'], (result) => {
        if (result.researchNotes) {
            document.getElementById('notes').value = result.researchNotes;
        }
    });

    document.getElementById('summarizeBtn')
        .addEventListener('click', summarizeText);

    document.getElementById('saveNotesBtn')
        .addEventListener('click', saveNotes);

    document.getElementById('saveSummaryBtn')
        .addEventListener('click', saveSummaryToFile);

    document.getElementById('downloadNotesBtn')
        .addEventListener('click', saveNotesToFile);
});


// ================== SUMMARIZE ==================

async function summarizeText() {
    try {
        const [tab] = await chrome.tabs.query({
            active: true,
            currentWindow: true
        });

        const [{ result }] = await chrome.scripting.executeScript({
            target: { tabId: tab.id },
            function: () => window.getSelection().toString()
        });

        if (!result || result.trim() === '') {
            showResult('Please select some text first.');
            return;
        }

        const response = await fetch(
            'http://localhost:8080/api/research/process',
            {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({
                    content: result,
                    operation: 'summarize'
                })
            }
        );

        if (!response.ok) {
            throw new Error(`API Error: ${response.status}`);
        }

        const text = await response.text();
        showResult(text.replace(/\n/g, '<br>'));

    } catch (error) {
        showResult('Error: ' + error.message);
    }
}


// ================== NOTES ==================

function saveNotes() {
    const notes = document.getElementById('notes').value;
    chrome.storage.local.set(
        { researchNotes: notes },
        () => alert('Notes saved successfully')
    );
}

function saveNotesToFile() {
    const notes = document.getElementById('notes').value;

    if (!notes || notes.trim() === '') {
        alert('No notes to download');
        return;
    }

    downloadFile(notes, 'research-notes.txt');
}


// ================== SUMMARY ==================

function saveSummaryToFile() {
    const summaryText = document.getElementById('results').innerText;

    if (!summaryText || summaryText.trim() === '') {
        alert('No summary to save');
        return;
    }

    downloadFile(summaryText, 'summary.txt');
}


// ================== HELPERS ==================

function downloadFile(content, filename) {
    const blob = new Blob([content], { type: 'text/plain' });
    const url = URL.createObjectURL(blob);

    const a = document.createElement('a');
    a.href = url;
    a.download = filename;

    document.body.appendChild(a);
    a.click();

    document.body.removeChild(a);
    URL.revokeObjectURL(url);
}

function showResult(content) {
    document.getElementById('results').innerHTML = `
        <div class="result-item">
            <div class="result-content">${content}</div>
        </div>`;
}
