import { Input, Table, Button } from 'antd';
import { ExportOutlined, CommentOutlined, UserOutlined, WarningTwoTone } from '@ant-design/icons';
import { Avatar, Switch } from 'antd';
import Gallery from './Gallery';
import { useState } from "react";

const CommentsTable = ({ comments, setComments }) => {
  let [searchQuery, setSearchQuery] = useState('');
  const filteredComments = comments.filter(comment => {
    return comment.text?.toLowerCase().indexOf(searchQuery) > -1;
  });

  const columns = [
    {
      render: (text, record, index) => {
        return <a href={`https://tvtalk.app/profiles/${record.user?.username}`} target='tv_talk' alt='View Profile'>
          {record.user?.image ? <Avatar src={record.user.image} /> : <Avatar icon={<UserOutlined />} />}
        </a>
      }
    },
    {
      title: '# Likes',
      dataIndex: 'likes_count',
      defaultSortOrder: 'descend',
      sorter: {
        compare: (a, b) => (a.likes_count || 0) - (b.likes_count || 0),
      },
      render: (text, record, index) => {
        return text || '-';
      }
    },
    {
      title: 'Subject',
      dataIndex: 'subject_type',
      sorter: {
        compare: (a, b) => ('' + a.subject_type).localeCompare(b.subject_type),
      }
    },
    {
      title: 'Subject Title',
      dataIndex: 'subject_title',
      sorter: {
        compare: (a, b) => ('' + a.subject_type).localeCompare(b.subject_type),
      }
    },
    {
      title: '# Media',
      dataIndex: 'image_count',
      defaultSortOrder: 'descend',
      sorter: {
        compare: (a, b) => a.image_count - b.image_count,
      },
      render: (text, record, index) => {
        return text || '-';
      }
    },
    {
      title: '# Videos',
      dataIndex: 'video_count',
      defaultSortOrder: 'descend',
      sorter: {
        compare: (a, b) => a.video_count - b.video_count,
      },
      render: (text, record, index) => {
        return text || '-';
      }
    },
    {
      title: 'Profanity',
      dataIndex: 'has_profanity',
      filters: [
        {
          text: 'Contains Profanity',
          value: true
        }
      ],
      // specify the condition of filtering result
      // here is that finding the name started with `value`
      onFilter: (value, record) => record.has_profanity === value,
      render: (text, record, index) => {
        if (record.has_profanity) {
          return <WarningTwoTone twoToneColor="#FF7900" />
        }
      }
    },
  
    {
      title: 'Created',
      dataIndex: 'created_at',
      sorter: (a, b) => Date.parse(a.created_at) - Date.parse(b.created_at),
      render: (text, record, index) => {
        return new Date(record.created_at).toLocaleDateString()
      }
    },
    {
      title: 'Visible',
      dataIndex: 'status',
      sorter: {
        compare: (a, b) => ('' + a.status).localeCompare(b.status),
      },
      filters: [
        {
          text: 'Active',
          value: 'active'
        },
        {
          text: 'Hidden',
          value: 'hidden'
        },
      ],
      // specify the condition of filtering result
      // here is that finding the name started with `value`
      onFilter: (value, record) => record.status === value,
      render: (text, record, index) => {
  
        return <Switch
          checked={text === 'active'}
          onChange={(isActive) => toggleStatus({isActive, id: record.id, type: record.type}) }
        />;
      },
    },
      {
        title: 'Visit',
        render: (text, record, index) => {
          let url;
    
          if (record.story_id) {
            url = `https://tvtalk.app/news/story/${record.story_id}#comment_${record.id}`
          } else if (record.comment_id || record.sub_comment_id) {
            // url = `https://tvtalk.app/networks/network/programs/${record.seriesId}/comments/${record.id}/replies`
          } else {
            url = `https://tvtalk.app/networks/network/programs/${record.seriesId}/comments/${record.id}`
          }
          
          if (!url) {
            return ''
          }
          
          return <a href={url} target='tv_talk' alt='View Comment'><ExportOutlined /></a>
        }
      }
  ];

  const toggleStatus = ({ id, type, isActive }) => {
    let url = `/admin/${type}s/${id}`;
  
    const requestOptions = {
      method: 'PUT',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        [type]: { status: isActive ? "active" : "inactive" }
      })
    };
  
    fetch(url, requestOptions)
      .then(response => response.json())
      .then((data) => {
        setComments(comments.map((comment) => {
          // type may be a Comment or SubComment
          if (comment.type === type && comment.id == id) {
            comment = data;
          }
  
          return comment;
        })
      );
    });
  }

  return (
    <>
      <section>
        <Input
          style={{marginBottom: "1.5em"}}
          placeholder='Search'
          onChange={(e) => setSearchQuery(e.target.value.toLowerCase())}
        />
      </section>

      <Table
        key='comments'
        rowKey='key'
        columns={columns}
        dataSource={filteredComments}
        expandable={{
          defaultExpandAllRows: true,
          expandedRowRender: record => {
            return <div>
              <Gallery images={record.images} videos={record.videos} />
              <p style={{ margin: 0 }}>{record.text}</p>
            </div>
          },
          rowExpandable: record => true,
        }}
        defaultExpandAllRows={true}
        expandedRowKeys={comments.map((comment) => comment.key)}
      >
      </Table>
    </>
  )
}

export default CommentsTable;


