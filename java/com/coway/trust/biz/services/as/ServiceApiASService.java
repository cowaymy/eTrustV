package com.coway.trust.biz.services.as;

import java.util.List;

import org.springframework.http.ResponseEntity;

import com.coway.trust.api.mobile.services.as.ASFailJobRequestDto;
import com.coway.trust.api.mobile.services.as.ASFailJobRequestForm;
import com.coway.trust.api.mobile.services.as.AfterServiceResultDto;
import com.coway.trust.api.mobile.services.as.AfterServiceResultForm;

/**
 * @ClassName : ServiceApiASService.java
 * @Description : Mobile After Service Data Save
 *
 * @History
 * Date              Author         Description
 * -------------  -----------  -------------
 * 2019. 09. 23.   Jun             First creation
 */
public interface ServiceApiASService {
	ResponseEntity<AfterServiceResultDto> asResult(List<AfterServiceResultForm> afterServiceForms) throws Exception;

	ResponseEntity<ASFailJobRequestDto> asFailJobRequest(ASFailJobRequestForm aSFailJobRequestForm) throws Exception;

	ResponseEntity<AfterServiceResultDto> asDtResult(List<AfterServiceResultForm> afterServiceForms) throws Exception;
}
