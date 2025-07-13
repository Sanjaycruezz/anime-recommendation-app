from django.db import models

# Create your models here.
class Anime(models.Model):
    anime=models.CharField(max_length=100)
    genere=models.CharField(max_length=2)
    rate=models.FloatField()
    emotion_tag = models.CharField(max_length=100, null=True, blank=True)

    def __str__(self):
        return self.anime

class LoginTable(models.Model):
    user_name = models.CharField(max_length=100)
    password = models.CharField(max_length=100)  # use hashed password ideally
    type = models.CharField(max_length=100)

    def __str__(self):
        return self.user_name


class user_table(models.Model):
    LOGIN=models.ForeignKey(LoginTable,on_delete=models.CASCADE)
    name=models.CharField(max_length=100)
    email=models.CharField(max_length=100)
    phone_no=models.BigIntegerField()
    age=models.BigIntegerField()
    photo = models.FileField()
    gender = models.CharField(max_length=100)