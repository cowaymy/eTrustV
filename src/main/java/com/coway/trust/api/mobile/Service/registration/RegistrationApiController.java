package com.coway.trust.api.mobile.Service.registration;

import java.util.ArrayList;
import java.util.List;
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

	@ApiOperation(value = "HeartServiceRegistrationSample", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/hearts", method = RequestMethod.POST)
	public ResponseEntity<HeartDto> heart(@RequestBody List<HeartForm> heartForms) throws Exception {

		String transactionId = "";
		// mobile 에서 받은 데이터를 로그 테이블에 insert......
		LOGGER.debug("### INSERT_HEART_LOG : {}", RegistrationConstants.IS_INSERT_HEART_LOG);
		LOGGER.debug("### TransactionId : {}", RegistrationConstants.IS_INSERT_HEART_LOG);
		if (RegistrationConstants.IS_INSERT_HEART_LOG) {

			List<Map<String, Object>> heartLogs = new ArrayList<>();
			for (HeartForm heart : heartForms) {
				heartLogs.addAll(heart.createMaps(heart));
			}

			// List<Map<String, Object>> heartLogs = heartForms.stream().flatMap(r -> r.createMaps(r))
			// .collect(Collectors.toList());
			registrationService.saveHearLogs(heartLogs);

			transactionId = heartForms.get(0).getTransactionId();
		}

		// business service....
		// TODO : heartService.xxxx 구현 필요.....

		// TODO : 리턴할 dto 구현.

		if (RegistrationConstants.IS_INSERT_HEART_LOG) {
			registrationService.updateSuccessStatus(transactionId);
		}

		return ResponseEntity.ok(HeartDto.create(transactionId));
	}
}
