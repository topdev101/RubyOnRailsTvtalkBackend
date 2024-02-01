import { Layout, Menu, Breadcrumb, PageHeader } from 'antd';

import AdminLayout from "../Layout";
import UsersTable from "./users/Table";
import UserForm from "./users/Form";
// import Shows from "./users/Shows";
// import UserSorter from "./users/UserSorter";
import { useState, useEffect } from "react";
import { Button, Space } from 'antd';

const { Header, Content, Footer } = Layout;

const Users = () => {
  const [users, setUsers] = useState([]);
  const [selectedUser, setSelectedUser] = useState(null);
  const [newUser, setNewUser] = useState(null);

  useEffect(() => {
    getUsers().then(users => {
      setUsers(users)
    })
  }, [selectedUser])

  const updateUsers = (_users) => {
    setUsers(_users);
    _users.forEach((user, i) => {
      const url = `/admin/users/${user.id}.json`;
      const data = { user: { position: i } }

      fetch(url, {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify(data)
      }).then(response => response.json())
        .then(data => {
        });
    })
  }

  const addUser = (user) => {
    // Add the new user to the table
    setUsers([user, ...users]);

    // Nullify the temporary user object
    // This has the desired side-effect of displaying the user table
    setNewUser(null);
  }

  return (
    <AdminLayout selectedMenuItem='users'>
      <Header>
        <div className="logo" />
        <Menu theme="dark" mode="horizontal" defaultSelectedKeys={['home']}>
          <Menu.Item key="home" onClick={() => setNewUser(null)}>All Users</Menu.Item>
          <Menu.Item key="form" onClick={() => setNewUser({})}>Create User</Menu.Item>
          <Menu.Item key="bots" onClick={() => window.location.href = '/admin/users/bots'} >Bot Browser</Menu.Item>
        </Menu>
      </Header>

      <Content style={{ padding: '0 50px' }}>
        <PageHeader title="Users" />
        <div className="site-layout-content">{selectedUser ? <Shows user={selectedUser} onDelete={() => setSelectedUser(null)} /> : ''}</div>
        
        { newUser === null ? <UsersTable users={users} /> : <UserForm user={newUser} onSave={addUser} /> }
      </Content>
    </AdminLayout>
  );
}

export default Users;

async function getUsers(page = 1) {
  const response = await fetch(`/admin/users.json?page=${page}`)
    .then(data => data.json());
  let users = response.results;
  if (response.pagination.next_page) {
    users = users.concat(await getUsers(response.pagination.next_page))
  }
  return users
}
