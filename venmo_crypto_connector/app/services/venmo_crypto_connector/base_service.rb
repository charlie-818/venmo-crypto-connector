module VenmoCryptoConnector
  class BaseService
    def self.call(*args, **kwargs)
      new(*args, **kwargs).call
    end

    private

    def success_result(data = {})
      OpenStruct.new(success?: true, data: data)
    end

    def failure_result(errors = [])
      OpenStruct.new(success?: false, errors: Array(errors))
    end

    def log_error(message, exception = nil)
      Rails.logger.error("#{self.class.name}: #{message}")
      Rails.logger.error(exception.backtrace.join("\n")) if exception
    end
  end
end
