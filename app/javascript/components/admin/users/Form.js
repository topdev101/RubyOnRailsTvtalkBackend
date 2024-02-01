import { Form, Input, Button, Alert } from 'antd';
import { useState } from "react";
import { PickerOverlay } from 'filestack-react'

const UserForm = ({ onSave }) => {
  const [showFilePicker, setShowFilePicker] = useState(false)
  const [profileImageURL, setProfileImageURL] = useState(null)
  const [errorMessage, setErrorMessage] = useState(null)
  const handleAddPhotoButtonClick = () => setShowFilePicker(true)
  const handleFilePickerClose = () => setShowFilePicker(false)

  const onFinish = (values) => {
    values.image = profileImageURL;

    fetch('/admin/users', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({ user: values })
    }).then(response => response.json())
      .then(data => {
        if (data.error) {
          setErrorMessage(data.error);
        } else {
          onSave(data);
          setErrorMessage(null);
        }
      });
  };

  const handleFileUpload = ({ filesUploaded }) => {
    setProfileImageURL(filesUploaded[0].url)
  }

  const onFinishFailed = (error) => {
    console.log(error);
  }

  const stringFields = [
    { name: 'name', required: true },
    { name: 'username', required: true },
    { name: 'email', required: true }
  ];

  return (
    <Form
      name="basic"
      labelCol={{ span: 8 }}
      wrapperCol={{ span: 16 }}
      initialValues={{ remember: true }}
      onFinish={onFinish}
      onFinishFailed={onFinishFailed}
      autoComplete="off"
    >
      {errorMessage && <Alert message={errorMessage} type="error" />}
      {stringFields.map((field) => {
        return <Form.Item
          label={field.name}
          name={field.name}
          rules={[{ required: field.required, message: `Required` }]}
        >
          <Input />
        </Form.Item>
      })}

      <Form.Item
        label="Profile image URL"
        name="image"

      >
        <div style={{ display: 'flex' }}>
          <Button onClick={handleAddPhotoButtonClick} >
            Upload profile image
          </Button>
          {profileImageURL && <img src={profileImageURL} height={32} />}
          <Input disabled value={profileImageURL} />
        </div>
      </Form.Item>

      <Form.Item
        label="Password"
        name="password"
        rules={[{ required: true, message: `Required` }]}
      >
        <Input.Password type='password'/>
      </Form.Item>

      <Form.Item
        label="Confirm Password"
        name="password_confirmation"
        rules={[{ required: true, message: `Required` }]}

      >
        <Input.Password type='password'/>
      </Form.Item>


      {showFilePicker && (
        <PickerOverlay
          action="pick"
          apikey={'A9BFYCPNxQeKh3wqeVSYkz'}
          onSuccess={handleFileUpload}
          actionOptions={{
            accept: ['image/*'],
            maxFiles: 1
          }}
          pickerOptions={{
            onClose: handleFilePickerClose
          }}
        />
      )}

      <Form.Item wrapperCol={{ offset: 8, span: 16 }}>
        <Button type="primary" htmlType="submit">
          Submit
        </Button>
      </Form.Item>
    </Form>
  );
};

export default UserForm;
