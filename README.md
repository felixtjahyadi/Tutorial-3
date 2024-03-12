# Tutorial 3 - Introduction to Game Programming

Name : Felix Tjahyadi

NPM : 2106638614

Godot version : 3.5

# Latihan Mandiri

## Double Jump
Untuk implementasi dari double jump sebagai berikut:

Pertama-tama saya menambahkan sebuah variabel yang akan berubah saat status player apakah sedang jump atau tidak

```
var double_jump = true
```

Kemudian, saya memanfaatkan variabel untuk memberikan kemampuan pada player untuk double jump

```
if is_on_floor() and Input.is_action_just_pressed('up'):
    $AnimatedSprite.play("Jump")
    velocity.y = jump_speed
    double_jump = true
if !is_on_floor() and Input.is_action_just_pressed('up') and double_jump == true:
    $AnimatedSprite.play("Jump")
    velocity.y = jump_speed
    double_jump = false
```

Kode tersebut mengecek keberadaan player dengan memanfaatkan `is_on_floor` dan status dari `double_jump` untuk memberi akses terhadap aksi double jump.

## Dashing

Untuk implementasi dari dashing, yang saya lakukan cukup panjang. Saya memanfaatkan referensi https://www.youtube.com/watch?v=PK1Fum0t4iU

Pertama-tama saya menambahkan variabel untuk status dari dashing dan juga aksi double tap untuk ke kanan dan kiri secara independen agar dapat memisahkan pembacaan input dari key

```
var dashing = false
var double_tap_right = false
var double_tap_left = false
```

Lalu saya tambahkan kondisi perubahan speed saat melakukan aksi dashing

```
func _process(delta):
    if dashing == true:
        speed = 1000
    elif dashing == false:
        speed = 400
```

Kemudian, menambahkan sebuah Timer untuk membuat sebuah interval dari aktivasi aksi menekan tombol dua kali. Timer akan dikoneksikan untuk perintah pada saat timeout

```
func _on_Timer_timeout():
	double_tap_right = false
	double_tap_left = false
```

Selanjutnya, saya menambahkan kode ke dalam `_process` untuk setiap aksi yang terjadi.

Yang pertama adalah pembacaan input dari mulai tombol dilepaskan lalu ke sebelum ditekan kembali untuk melakukan dashing. Bagian ini juga sebagai penghenti aksi dashing saat melepaskan tombol setelah sudah melaju cepat akibat menekan tombol dua kali.
```
if Input.is_action_just_released('left'):
    $AnimatedSprite.stop()
    if dashing == true:
        dashing = false
    double_tap_left = true
    $Timer.start()
    
if Input.is_action_just_released('right'):
    $AnimatedSprite.stop()
    if dashing == true:
        dashing = false
    double_tap_right = true
    $Timer.start()
```

Kemudian, saya menambahkan kode untuk merubah status dari `dashing` tersebut untuk meningkatkan kecepatan setelah menekan kembali tombol untuk kedua kalinya

```
if Input.is_action_just_pressed('left'):
    if double_tap_left == true:
        dashing = true
        
if Input.is_action_just_pressed('right'):
    if double_tap_right == true:
        dashing = true
```
## Crouching

Untuk implementasi crouching sebagi berikut:

Pertama-tama saya menambahkan tombol khusus untuk melakukan crouching yaitu tombol "c".

Kemudian barulah saya membuat code untuk mengubah kecepatan selama tombol tersebut tertekan.

```
if Input.is_action_pressed("crouch"):
    $AnimatedSprite.play("Crouch")
    speed = 50
    jump_speed = 0
else:
    $AnimatedSprite.stop()
    speed = 400
    jump_speed = -600
```

# Tutorial 5 - Assets Creation & Integration

# Latihan Mandiri
## New Object: Slime Enemy

Untuk latihan mandiri pada tutorial 5 ini, saya menambahkan sebuah object baru yaitu sebuah slime berwarna biru. 

### Langkah Awal
Untuk tahap pertama atau langkah awal dari saya mengerjakan latihan ini, saya mulai dengan membuat Sprite sendiri. Saya membuat Sprite tersebut dengan memanfaatkan aplikasi FireAlpaca dengan ukuran Slime sebesar 16 x 16 pixel. Setelah selesai membuatnya, saya mengeksport ke dalam folder assets untuk digunakan nantinya. Kemudian, saya mulai mencari secara online, audio dan sound effect yang akan saya gunakan dalam latihan ini.

### Langkah 1: Enemy Making
- Saya membuat scene baru untuk musuh yang mana menggunakan KinematicBody2D
- Kemudian menambahkan AnimatedSprite, CollisionShape2D, dua buah Area2D untuk interaksi dengan Player, dan juga AudioStreamPlayer2D
- Pada AnimatedSprite saya menambahkan sprite yang telah saya buat dengan animasinya dan saya buat CollisionShape yang sesuai.
- Kemudian saya mengatur kedua Area2D sebagai area deteksi interaksi dengan Player, satu yang berada pada bagian atas dari musuh dan yang satu lagi untuk sisi dari musuh
- Terakhir sebelum menulis script saya tambahkan sound effect untuk interaksi dengan musuh

Berikut script yang saya tulis untuk Slime:
```
extends KinematicBody2D

var speed = 50
var velocity = Vector2()
var direction = 1

func _ready():
	$AnimatedSprite.play("walk")

	
func _physics_process(delta):
	
	if is_on_wall():
		direction = direction*-1
		$AnimatedSprite.flip_h = not $AnimatedSprite.flip_h
	
	velocity.y += 20
	
	velocity.x = speed * direction
	
	velocity = move_and_slide(velocity, Vector2.UP)


func _on_TopCheck_body_entered(body):
	$SoundBounce.play()
	speed = 0
	body.bounce()


func _on_TopCheck_body_exited(body):
	$AnimatedSprite.play("walk")
	speed = 50


func _on_SideCheck_body_entered(body):
	get_tree().change_scene("res://scenes/Main.tscn")

```

Dalam script akan menjalankan Slime secara otomatis dan jika dia bertabrakan dengan dinding akan berbalik. Script juga menghubungkan kedua Area2D dengan interaksi masing-masing. Jika Player mengenai bagian atas akan lompat secara otomatis dan ada suara yang dimainkan. Jika Player sudah lompat akan berjalan kembali Slime. Terakhir jika Player terkena sisi Slime akan mereset level.

### Langkah 2: Player Udpate
Saya memperbarui beberapa hal untuk AnimatedPlayer yang ada permainan:
- Pertama menambahkan sebuah fungsi untuk melompat saat terkena slime yaitu fungsi bounce
```
func bounce():
	velocity.y = jump_speed * 1.2
	double_jump = true
```
- Kedua menambahkan sebuah AudioStreamPlayer2D untuk memutarkan sound effect pada saat Player melakukan lompatan
- Ketiga saya menambahkan sebuah chid Listener2D agar sesuai dengan posisi Player terhadap sumber suara di Main level maka tingkat volume dan sumber suara pada headphone akan berubah di mana semakin dekat dengan sumber maka semakin terdengar pada kedua headphone.

### Langkah 3: World Sound
Pada langkah terakhir, saya menambahkan sebuah AudioStreamPlayer2D yang akan memutar sebuah audio secara otomatis saat permainan dimulai.