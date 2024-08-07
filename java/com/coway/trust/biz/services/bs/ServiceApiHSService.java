package com.coway.trust.biz.services.bs;

import java.util.List;

import org.springframework.http.ResponseEntity;

import com.coway.trust.api.mobile.services.heartService.HSFailJobRequestDto;
import com.coway.trust.api.mobile.services.heartService.HSFailJobRequestForm;
import com.coway.trust.api.mobile.services.heartService.HeartServiceResultDto;
import com.coway.trust.api.mobile.services.heartService.HeartServiceResultForm;

/**
 * @ClassName : ServiceApiHSService.java
 * @Description : Mobile Heart Service Data Save
 *
 * @History
 * Date              Author         Description
 * -------------  -----------  -------------
 * 2019. 09. 20.   Jun             First creation
 */
public interface ServiceApiHSService {
	ResponseEntity<HeartServiceResultDto> hsResult(List<HeartServiceResultForm> heartForms) throws Exception;

	ResponseEntity<HSFailJobRequestDto> hsFailJobRequest(HSFailJobRequestForm hSFailJobRequestForm) throws Exception;

	ResponseEntity<HeartServiceResultDto> htResult(List<HeartServiceResultForm> heartForms) throws Exception;

	ResponseEntity<HSFailJobRequestDto> htFailJobRequest(HSFailJobRequestForm hSFailJobRequestForm) throws Exception;
}
