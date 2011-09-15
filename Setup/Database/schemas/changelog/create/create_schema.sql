CREATE TABLE ${changelogTableName} (
    change_number INTEGER NOT NULL PRIMARY KEY,
    complete_dt TIMESTAMP NOT NULL,
    applied_by VARCHAR(100) NOT NULL,
    description VARCHAR(500) NOT NULL
);
