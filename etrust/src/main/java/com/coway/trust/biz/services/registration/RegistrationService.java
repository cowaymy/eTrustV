package com.coway.trust.biz.services.registration;

import java.util.List;
import java.util.Map;

public interface RegistrationService {

	void saveHearLogs(List<Map<String, Object>> logs);

	void updateSuccessStatus(String transactionId);
}
