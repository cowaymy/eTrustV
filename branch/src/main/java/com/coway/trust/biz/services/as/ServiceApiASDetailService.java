package com.coway.trust.biz.services.as;

import java.util.Map;

import org.springframework.http.ResponseEntity;

import com.coway.trust.api.mobile.services.as.ASFailJobRequestDto;
import com.coway.trust.api.mobile.services.as.AfterServiceResultDto;

/**
 * @ClassName : ServiceApiHSDetailService.java
 * @Description : Mobile Heart Service Data Save
 *
 * @History
 * Date              Author         Description
 * -------------  -----------  -------------
 * 2019. 09. 20.   Jun             First creation
 */
public interface ServiceApiASDetailService {
	ResponseEntity<AfterServiceResultDto> asResultProc(Map<String, Object> insApiresult) throws Exception;

	ResponseEntity<ASFailJobRequestDto> asFailJobRequestProc(Map<String, Object> params) throws Exception;

	ResponseEntity<AfterServiceResultDto> asDtResultProc(Map<String, Object> insApiresult) throws Exception;
}
