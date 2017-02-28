from sqlalchemy import *
from migrate import *


from migrate.changeset import schema
pre_meta = MetaData()
post_meta = MetaData()
apartment = Table('apartment', post_meta,
    Column('id', Integer, primary_key=True, nullable=False),
    Column('aptname', String(length=64)),
)

user = Table('user', post_meta,
    Column('id', Integer, primary_key=True, nullable=False),
    Column('username', String(length=64)),
    Column('password', String(length=64)),
    Column('email', String(length=120)),
    Column('phone', String(length=10)),
    Column('aid', Integer),
)


def upgrade(migrate_engine):
    # Upgrade operations go here. Don't create your own engine; bind
    # migrate_engine to your metadata
    pre_meta.bind = migrate_engine
    post_meta.bind = migrate_engine
    post_meta.tables['apartment'].create()
    post_meta.tables['user'].columns['aid'].create()


def downgrade(migrate_engine):
    # Operations to reverse the above upgrade go here.
    pre_meta.bind = migrate_engine
    post_meta.bind = migrate_engine
    post_meta.tables['apartment'].drop()
    post_meta.tables['user'].columns['aid'].drop()
