import { Layout, Menu, Breadcrumb, PageHeader } from 'antd';
import Sidebar from "./Sidebar";

const { Footer } = Layout;

const AdminLayout = ({ title, selectedMenuItem, children }) => {
  return (
    <Layout className="layout">
      <Sidebar selected={selectedMenuItem} />
      <Layout>
        {children}
        <Footer theme="dark" style={{ textAlign: 'center' }}>TV Talk</Footer>
      </Layout>
    </Layout>
  )
}

export default AdminLayout;