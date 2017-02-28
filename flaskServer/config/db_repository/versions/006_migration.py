from sqlalchemy import *
from migrate import *


from migrate.changeset import schema
pre_meta = MetaData()
post_meta = MetaData()
apartment = Table('apartment', post_meta,
    Column('id', Integer, primary_key=True, nullable=False),
    Column('aptname', String(length=64)),
    Column('latitude', String(length=64)),
    Column('longitude', String(length=64)),
)


def upgrade(migrate_engine):
    # Upgrade operations go here. Don't create your own engine; bind
    # migrate_engine to your metadata
    pre_meta.bind = migrate_engine
    post_meta.bind = migrate_engine
    post_meta.tables['apartment'].columns['latitude'].create()
    post_meta.tables['apartment'].columns['longitude'].create()


def downgrade(migrate_engine):
    # Operations to reverse the above upgrade go here.
    pre_meta.bind = migrate_engine
    post_meta.bind = migrate_engine
    post_meta.tables['apartment'].columns['latitude'].drop()
    post_meta.tables['apartment'].columns['longitude'].drop()
