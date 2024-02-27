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