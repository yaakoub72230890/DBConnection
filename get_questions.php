<?php
require_once 'connection.php';

$sql = "SELECT q.id as question_id, q.question_text, q.correct_answer,
        a.id as answer_id, a.answer_text
        FROM questions q 
        LEFT JOIN answers a ON q.id = a.question_id";

$result = $conn->query($sql);

$questions = [];

if ($result->num_rows > 0) {
    while($row = $result->fetch_assoc()) {
        $q_id = $row['question_id'];
        
        // Group answers under their specific question
        if (!isset($questions[$q_id])) {
            $questions[$q_id] = [
                "id" => $q_id,
                "question" => $row['question_text'],
                "correct" => $row['correct_answer'],
                "answers" => []
            ];
        }
        
        if ($row['answer_id']) {
            $questions[$q_id]['answers'][] = [
                "id" => $row['answer_id'],
                "text" => $row['answer_text'],
            ];
        }
    }
}

// Re-index array to remove ID keys and output JSON
echo json_encode(array_values($questions));

$conn->close();
?>