import React from 'react'
import { NotificationContext } from '~/components/Contexts/NotificationContext'

class ErrorBoundary extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      hasError: false,
      error: null
    };
  }

  static getDerivedStateFromError(error) {
    // Update state so the next render will show the fallback UI.
    return { hasError: true, error };
  }

  componentDidCatch(error, errorInfo) {
    // You can also log the error to an error reporting service
    this.setState({hasError: true, error})
  }

  render() {
    if(this.state.hasError){
      return <p>Something went wrong here</p>
    }
    return this.props.children
  }
}

export default ErrorBoundary