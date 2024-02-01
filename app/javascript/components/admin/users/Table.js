import { Table } from 'antd';
import { ExportOutlined, UserOutlined, AppleOutlined, GoogleOutlined, FacebookOutlined, MailOutlined, BranchesOutlined } from '@ant-design/icons';
import { Avatar } from 'antd';
import { RobotOutlined } from '@ant-design/icons';

const columns = [
  {
    render: (text, record, index) => {
      return record.image ? <Avatar src={record.image} /> : <Avatar icon={<UserOutlined />} />;
    }
  },
  {
    title: 'Username',
    dataIndex: 'username',
    // specify the condition of filtering result
    // here is that finding the name started with `value`
    onFilter: (value, record) => record.username.indexOf(value) === 0,
    sorter: (a, b) => a.username.localeCompare(b.username),
    sortDirections: ['descend'],
    render: (text, record, index) => {
      return record.is_robot ? <div><a href={`/admin/users/${record.id}/login`} target="robots"><RobotOutlined /></a> {text}</div> : text;
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
    title: '# Comments',
    dataIndex: 'comments_count',
    defaultSortOrder: 'descend',
    sorter: {
      compare: (a, b) => (a.comments_count || 0) - (b.comments_count || 0),
    },
    render: (text, record, index) => {
      return text || '-';
    }
  },
  {
    title: 'Login',
    dataIndex: 'login_type',
    filters: [
      {
        text: 'Email',
        value: 'Email'
      },
      {
        text: 'Google',
        value: 'Google'
      },
      {
        text: 'Facebook',
        value: 'Facebook'
      },
      {
        text: 'Apple',
        value: 'Apple'
      }
    ],
    // specify the condition of filtering result
    // here is that finding the name started with `value`
    onFilter: (value, record) => record.login_type.indexOf(value) === 0,
    sorter: (a, b) => a.login_type.localeCompare(b.login_type),
    sortDirections: ['descend'],
    render: (text, record, index) => {
      if (record.login_type == 'Google') {
        return <GoogleOutlined />
      } else if (record.login_type == 'Facebook') {
        return <FacebookOutlined />
      } else if (record.login_type == 'Apple') {
        return <AppleOutlined />
      } else {
        return <MailOutlined />
      }
    }
  },
  {
    title: 'Zip',
    dataIndex: 'zipcode',
    sorter: (a, b) => (a.zipcode || 0) - (b.zipcode || 0),
    render: (text, record, index) => {
      return record.zipcode || '-'
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
    title: 'Profile',
    key: 'id',
    dataIndex: 'id',
    render: (text, record, index) => {
      return <a href={`https://tvtalk.app/profiles/${record.username}`} target='tv_talk' alt='View Profile'><ExportOutlined /></a>
    }
  }
];

const data = [
  {
    key: '1',
    name: 'John Brown',
    age: 32,
    address: 'New York No. 1 Lake Park',
  },
  {
    key: '2',
    name: 'Jim Green',
    age: 42,
    address: 'London No. 1 Lake Park',
  },
  {
    key: '3',
    name: 'Joe Black',
    age: 32,
    address: 'Sidney No. 1 Lake Park',
  },
  {
    key: '4',
    name: 'Jim Red',
    age: 32,
    address: 'London No. 2 Lake Park',
  },
];

function onChange(pagination, filters, sorter, extra) {
  console.log('params', pagination, filters, sorter, extra);
}


const UsersTable = ({ users }) => {
  // const [form] = Form.useForm();

  return (
    <Table columns={columns} dataSource={users} onChange={onChange}>

    </Table>
  )
}

export default UsersTable;


