package com.coway.trust.biz.services.bs;

import java.util.List;
import java.util.Map;

import org.springframework.http.ResponseEntity;

import com.coway.trust.api.mobile.services.heartService.HSFailJobRequestDto;
import com.coway.trust.api.mobile.services.heartService.HeartServiceResultDto;

/**
 * @ClassName : ServiceApiHSDetailService.java
 * @Description : Mobile Heart Service Data Save
 *
 * @History
 * Date              Author         Description
 * -------------  -----------  -------------
 * 2019. 09. 20.   Jun             First creation
 */
public interface ServiceApiHSDetailService {
	ResponseEntity<HeartServiceResultDto> hsResultProc(Map<String, Object> insApiresult, Map<String, Object> params, List<Object> paramsDetailList) throws Exception;

	ResponseEntity<HSFailJobRequestDto> hsFailJobRequestProc(Map<String, Object> params) throws Exception;

	ResponseEntity<HeartServiceResultDto> htResultProc(Map<String, Object> insApiresult, Map<String, Object> params, List<Object> paramsDetailList) throws Exception;

	ResponseEntity<HSFailJobRequestDto> htFailJobRequestProc(Map<String, Object> params) throws Exception;
}
