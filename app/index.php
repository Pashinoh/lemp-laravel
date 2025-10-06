<?php
$servername = "db";
$username = "user";
$password = "user123";
$dbname = "appdb";

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
  die("❌ Koneksi gagal: " . $conn->connect_error);
}
echo "<h2>✅ Koneksi ke database berhasil!</h2>";
echo "<p>PHP version: " . phpversion() . "</p>";

// Tes query sederhana
$sql = "SHOW TABLES";
$result = $conn->query($sql);

if ($result && $result->num_rows > 0) {
  echo "<p>Daftar tabel dalam database:</p><ul>";
  while ($row = $result->fetch_array()) {
    echo "<li>" . $row[0] . "</li>";
  }
  echo "</ul>";
} else {
  echo "<p>Database kosong, belum ada tabel.</p>";
}

$conn->close();
?>
