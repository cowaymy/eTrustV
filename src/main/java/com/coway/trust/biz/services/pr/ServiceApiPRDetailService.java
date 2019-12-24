package com.coway.trust.biz.services.pr;

import java.util.Map;

import org.springframework.http.ResponseEntity;

import com.coway.trust.api.mobile.services.productRetrun.PRFailJobRequestDto;
import com.coway.trust.api.mobile.services.productRetrun.ProductReturnResultDto;

/**
 * @ClassName : ServiceApiPRDetailService.java
 * @Description : Mobile Product Return Data Save
 *
 * @History
 * Date              Author         Description
 * -------------  -----------  -------------
 * 2019. 09. 24.   Jun             First creation
 */
public interface ServiceApiPRDetailService {
	ResponseEntity<ProductReturnResultDto> productReturnResultProc(Map<String, Object> cvMp) throws Exception;

	ResponseEntity<PRFailJobRequestDto> prReAppointmentRequestProc(Map<String, Object> params) throws Exception;

	ResponseEntity<ProductReturnResultDto> productReturnDtResultProc(Map<String, Object> cvMp) throws Exception;
}
