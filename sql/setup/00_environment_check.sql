SELECT
    @@SERVERNAME AS server_name,
    @@VERSION AS sql_server_version,
    SERVERPROPERTY('Edition') AS edition,
    SERVERPROPERTY('ProductVersion') AS product_version,
    SERVERPROPERTY('ProductMajorVersion') AS major_version;