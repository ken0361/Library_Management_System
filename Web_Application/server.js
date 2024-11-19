const express = require('express');
const bodyParser = require('body-parser');

const app = express();

const database = {
	query: [
		{
			query_id: '00000001',
			user_id: 'stu190001',
			book_name: 'java program',
			author_name: 'Andrew',
			book_status: 'null'
		},
		{
			query_id: '00000002',
			user_id: 'stu193333',
			book_name: 'C programming',
			author_name: 'Neill',
			book_status: 'null'
		}

	]
}


app.use(express.static(__dirname + '/public'));

// app.get('/Login', (req, res)=>{
// 	res.send('This is working.')
// })

// app.post('/signin', (req, res) => {
// 	if (req.body.email === database.users[0].email && 
// 		req.body.password === database.users[0].password ){
// 		res.json('success');
// 	} else {
// 		res.status(400).json('error logging in')
// 	}
// })

app.post('/Query', (req, res) => {
	const { book_name, author_name } = req.body;
	database.query.push({
		query_id: '00000005',
		user_id: 'stu1968555',
		book_name: 'book_name',
		author_name: 'author_name',
		book_status: 'null'
	})
	res.json(database.query[database.query.length-1]);
})

app.listen(3000, ()=> {
	console.log('app is running on port 3000');
});

/*
res = this is working
signin -> POST = success/fail
register -> POST = user
/profile/:userId -> GET = user
/image -> PUT -> user

*/