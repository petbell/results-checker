# This is an auto-generated Django model module.
# You'll have to do the following manually to clean this up:
#   * Rearrange models' order
#   * Make sure each model has one field with primary_key=True
#   * Make sure each ForeignKey and OneToOneField has `on_delete` set to the desired behavior
#   * Remove `managed = False` lines if you wish to allow Django to create, modify, and delete the table
# Feel free to rename the models, but don't rename db_table values or field names.
from django.db import models


class Tbcard(models.Model):
    serial = models.AutoField(primary_key=True)
    pin = models.IntegerField(unique=True)
    print_date = models.DateTimeField()
    expiry = models.TextField()
    used = models.IntegerField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'TbCard'


class Tbresults(models.Model):
    student_id = models.AutoField(primary_key=True)
    student_name = models.TextField(blank=True, null=True)
    maths = models.IntegerField(db_column='Maths', blank=True, null=True)  # Field name made lowercase.
    english = models.IntegerField(db_column='English', blank=True, null=True)  # Field name made lowercase.
    economics = models.IntegerField(db_column='Economics', blank=True, null=True)  # Field name made lowercase.
    biology = models.IntegerField(db_column='Biology', blank=True, null=True)  # Field name made lowercase.
    total = models.TextField(db_column='Total', blank=True, null=True)  # Field name made lowercase. This field type is a guess.
    grade = models.TextField(db_column='Grade', blank=True, null=True)  # Field name made lowercase.

    class Meta:
        managed = False
        db_table = 'TbResults'


class Tbtransact(models.Model):
    student_id = models.IntegerField(blank=True, null=True)
    pin = models.IntegerField(blank=True, null=True)
    card_use = models.IntegerField(blank=True, null=True)
    use_date = models.DateTimeField()

    class Meta:
        managed = False
        db_table = 'TbTransact'


class Tbused(models.Model):
    student_id = models.IntegerField(blank=True, null=True)
    pin = models.IntegerField(blank=True, null=True)
    last_date = models.TextField()

    class Meta:
        managed = False
        db_table = 'TbUsed'


class Test(models.Model):
    a = models.IntegerField(blank=True, null=True)
    b = models.IntegerField(blank=True, null=True)
    c = models.TextField(blank=True, null=True)  # This field type is a guess.

    class Meta:
        managed = False
        db_table = 'Test'


class AuthGroup(models.Model):
    name = models.CharField(unique=True, max_length=150)

    class Meta:
        managed = False
        db_table = 'auth_group'


class AuthGroupPermissions(models.Model):
    group = models.ForeignKey(AuthGroup, models.DO_NOTHING)
    permission = models.ForeignKey('AuthPermission', models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'auth_group_permissions'
        unique_together = (('group', 'permission'),)


class AuthPermission(models.Model):
    content_type = models.ForeignKey('DjangoContentType', models.DO_NOTHING)
    codename = models.CharField(max_length=100)
    name = models.CharField(max_length=255)

    class Meta:
        managed = False
        db_table = 'auth_permission'
        unique_together = (('content_type', 'codename'),)


class AuthUser(models.Model):
    password = models.CharField(max_length=128)
    last_login = models.DateTimeField(blank=True, null=True)
    is_superuser = models.BooleanField()
    username = models.CharField(unique=True, max_length=150)
    last_name = models.CharField(max_length=150)
    email = models.CharField(max_length=254)
    is_staff = models.BooleanField()
    is_active = models.BooleanField()
    date_joined = models.DateTimeField()
    first_name = models.CharField(max_length=150)

    class Meta:
        managed = False
        db_table = 'auth_user'


class AuthUserGroups(models.Model):
    user = models.ForeignKey(AuthUser, models.DO_NOTHING)
    group = models.ForeignKey(AuthGroup, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'auth_user_groups'
        unique_together = (('user', 'group'),)


class AuthUserUserPermissions(models.Model):
    user = models.ForeignKey(AuthUser, models.DO_NOTHING)
    permission = models.ForeignKey(AuthPermission, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'auth_user_user_permissions'
        unique_together = (('user', 'permission'),)


class Card(models.Model):
    serial = models.AutoField(primary_key=True)
    pin = models.IntegerField(unique=True)
    print_date = models.DateTimeField()
    expiry = models.TextField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'card'


class DjangoAdminLog(models.Model):
    object_id = models.TextField(blank=True, null=True)
    object_repr = models.CharField(max_length=200)
    action_flag = models.PositiveSmallIntegerField()
    change_message = models.TextField()
    content_type = models.ForeignKey('DjangoContentType', models.DO_NOTHING, blank=True, null=True)
    user = models.ForeignKey(AuthUser, models.DO_NOTHING)
    action_time = models.DateTimeField()

    class Meta:
        managed = False
        db_table = 'django_admin_log'


class DjangoContentType(models.Model):
    app_label = models.CharField(max_length=100)
    model = models.CharField(max_length=100)

    class Meta:
        managed = False
        db_table = 'django_content_type'
        unique_together = (('app_label', 'model'),)


class DjangoMigrations(models.Model):
    app = models.CharField(max_length=255)
    name = models.CharField(max_length=255)
    applied = models.DateTimeField()

    class Meta:
        managed = False
        db_table = 'django_migrations'


class DjangoSession(models.Model):
    session_key = models.CharField(primary_key=True, max_length=40)
    session_data = models.TextField()
    expire_date = models.DateTimeField()

    class Meta:
        managed = False
        db_table = 'django_session'


class Results(models.Model):
    student_id = models.AutoField(primary_key=True)
    maths = models.IntegerField(db_column='Maths', blank=True, null=True)  # Field name made lowercase.
    english = models.IntegerField(db_column='English', blank=True, null=True)  # Field name made lowercase.
    economics = models.IntegerField(db_column='Economics', blank=True, null=True)  # Field name made lowercase.
    biology = models.IntegerField(db_column='Biology', blank=True, null=True)  # Field name made lowercase.
    total = models.IntegerField(db_column='Total', blank=True, null=True)  # Field name made lowercase.
    grade = models.TextField(db_column='Grade', blank=True, null=True)  # Field name made lowercase.

    class Meta:
        managed = False
        db_table = 'results'


class ResultsTbcards(models.Model):
    serial = models.IntegerField()
    pin = models.IntegerField(unique=True)
    print_date = models.DateTimeField()
    expiry_date = models.DateTimeField()

    class Meta:
        managed = False
        db_table = 'results_tbcards'


class ResultsTbresults(models.Model):
    student_id = models.AutoField(primary_key=True)

    class Meta:
        managed = False
        db_table = 'results_tbresults'


class ResultsTbtransact(models.Model):
    date = models.DateTimeField()
    pin = models.ForeignKey(ResultsTbcards, models.DO_NOTHING)
    student_id = models.ForeignKey(ResultsTbresults, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'results_tbtransact'
