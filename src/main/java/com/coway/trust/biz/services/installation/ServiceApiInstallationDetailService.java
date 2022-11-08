package com.coway.trust.biz.services.installation;

import java.util.Map;

import org.springframework.http.ResponseEntity;

import com.coway.trust.api.mobile.services.installation.InstallFailJobRequestDto;
import com.coway.trust.api.mobile.services.installation.InstallationResultDto;

/**
 * @ClassName : ServiceApiInstallationDetailService.java
 * @Description : Mobile Installation Data Save
 *
 *
 * @History Date Author Description ------------- ----------- ------------- 2019. 09. 17. Jun First creation
 */
public interface ServiceApiInstallationDetailService {
  ResponseEntity<InstallationResultDto> installationResultProc(Map<String, Object> insApiresult) throws Exception;

  ResponseEntity<InstallFailJobRequestDto> installFailJobRequestProc(Map<String, Object> params) throws Exception;

  ResponseEntity<InstallationResultDto> installationDtResultProc(Map<String, Object> insApiresult) throws Exception;

  //void installationResultProcSendEmail(Map<String, Object> params);
}
