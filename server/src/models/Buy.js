module.exports = (sequelize, DataTypes) => {
    const Buy = sequelize.define('Buy', {
        bookid: DataTypes.STRING,
        userid: DataTypes.STRING,
        qty: DataTypes.STRING,
        email: DataTypes.STRING,
        clientStatus: DataTypes.STRING,
        shopStatus: DataTypes.STRING,
        booktitle: DataTypes.STRING,
        username: DataTypes.STRING,
        userlastname: DataTypes.STRING,
        prices: DataTypes.STRING
    })
    return Buy
}