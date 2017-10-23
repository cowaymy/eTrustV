package com.coway.trust.api.mobile.Service.registration;

import java.util.HashMap;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.services.registration.RegistrationService;

import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;

@Api(value = "Registration api", description = "Registration api")
@RestController(value = "RegistrationApiController")
@RequestMapping(AppConstants.MOBILE_API_BASE_URI + "/registration")
public class RegistrationApiController {
	private static final Logger LOGGER = LoggerFactory.getLogger(RegistrationApiController.class);

	@Autowired
	private RegistrationService registrationService;

	@ApiOperation(value = "Heart", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/heart", method = RequestMethod.POST)
	public ResponseEntity<HeartDto> heart(@RequestBody HeartForm heartForm) throws Exception {

		// mobile 에서 받은 데이터를 로그 테이블에 insert......
		LOGGER.debug("### INSERT_HEART_LOG : {}", RegistrationConstants.INSERT_HEART_LOG);
		if (RegistrationConstants.INSERT_HEART_LOG) {
			registrationService.saveHearLog(heartForm.createMap(heartForm));
		}

		// business service....
		// TODO : heartService.xxxx 구현 필요.....

		// TODO : 리턴할 dto 구현. 현재는 임시로 transactionId만 리턴함.
		Map<String, Object> sampleData = new HashMap<>();
		sampleData.put("transactionId", heartForm.getTransactionId());

		return ResponseEntity.ok(HeartDto.create(sampleData));
	}
}
