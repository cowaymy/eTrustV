package com.coway.trust.biz.services.pr;

import java.util.List;

import org.springframework.http.ResponseEntity;

import com.coway.trust.api.mobile.services.productRetrun.PRFailJobRequestDto;
import com.coway.trust.api.mobile.services.productRetrun.PRFailJobRequestForm;
import com.coway.trust.api.mobile.services.productRetrun.ProductReturnResultDto;
import com.coway.trust.api.mobile.services.productRetrun.ProductReturnResultForm;

/**
 * @ClassName : ServiceApiPRService.java
 * @Description : Mobile Product Return Data Save
 *
 * @History
 * Date              Author         Description
 * -------------  -----------  -------------
 * 2019. 09. 24.   Jun             First creation
 */
public interface ServiceApiPRService {
	ResponseEntity<ProductReturnResultDto> productReturnResult(List<ProductReturnResultForm> productReturnResultForm) throws Exception;

	ResponseEntity<PRFailJobRequestDto> prReAppointmentRequest(PRFailJobRequestForm pRFailJobRequestForm) throws Exception;

	ResponseEntity<ProductReturnResultDto> productReturnDtResult(List<ProductReturnResultForm> productReturnResultForm) throws Exception;

	ResponseEntity<PRFailJobRequestDto> prReAppointmentDtRequest(PRFailJobRequestForm pRFailJobRequestForm) throws Exception;
}
