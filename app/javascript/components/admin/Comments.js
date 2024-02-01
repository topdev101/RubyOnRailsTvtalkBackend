import { Layout, Menu, Breadcrumb, PageHeader } from 'antd';

import AdminLayout from "../Layout";
import CommentsTable from "./comments/Table";
import { useState, useEffect } from "react";

const { Header, Content, Footer } = Layout;

const Comments = () => {
  const [comments, setComments] = useState([]);
  const [selectedComment, setSelectedComment] = useState(null);

  useEffect(() => {
    getComments().then(comments => {
      getSubComments().then(subComments => {
        setComments(comments.concat(subComments))
      })
    })
  }, [selectedComment])

  return (
    <AdminLayout selectedMenuItem='comments'>
      <Header>
        <div className="logo" />
        <Menu theme="dark" mode="horizontal" defaultSelectedKeys={['home']}>
          <Menu.Item key="home" onClick={() => setSelectedComment(null)}>All Comments</Menu.Item>
          <Menu.Item key="form"></Menu.Item>
          {comments.map((comment, i) => {
            return <Menu.Item key={i} onClick={() => setSelectedComment(comment)}>{comment.title}</Menu.Item>
          })}
        </Menu>
      </Header>

      <Content style={{ padding: '0 50px' }}>
        <PageHeader title="Comments" />
        <div className="site-layout-content">{selectedComment ? <Shows comment={selectedComment} onDelete={() => setSelectedComment(null)} /> : ''}</div>
        <CommentsTable comments={comments} setComments={setComments} />
      </Content>
    </AdminLayout>
  );
}

export default Comments;

async function getComments(page = 1) {
  const response = await fetch(`/admin/comments.json?page=${page}`)
    .then(data => data.json());
  let comments = response.results;
  
  if (response.pagination.next_page) {
    comments = comments.concat(await getComments(response.pagination.next_page))
  }

  return comments;
}

async function getSubComments(page = 1) {
  const response = await fetch(`/admin/sub_comments.json?page=${page}`)
    .then(data => data.json());
  let sub_comments = response.results;
  
  if (response.pagination.next_page) {
    sub_comments = sub_comments.concat(await getSubComments(response.pagination.next_page))
  }

  return sub_comments;
}
