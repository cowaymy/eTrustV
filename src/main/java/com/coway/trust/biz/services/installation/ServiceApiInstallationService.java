package com.coway.trust.biz.services.installation;

import java.util.List;

import org.springframework.http.ResponseEntity;

import com.coway.trust.api.mobile.services.installation.InstallFailJobRequestDto;
import com.coway.trust.api.mobile.services.installation.InstallFailJobRequestForm;
import com.coway.trust.api.mobile.services.installation.InstallationResultDto;
import com.coway.trust.api.mobile.services.installation.InstallationResultForm;

/**
 * @ClassName : ServiceApiInstallationService.java
 * @Description : Mobile Installation Data Save
 *
 * @History Date Author Description
 * ------------- ----------- -------------
 * 2019. 09. 17. Jun First creation
 *
 */
public interface ServiceApiInstallationService {
  ResponseEntity<InstallationResultDto> installationResult(List<InstallationResultForm> installationResultForms) throws Exception;

  ResponseEntity<InstallFailJobRequestDto> installFailJobRequest(InstallFailJobRequestForm installFailJobRequestForm) throws Exception;

  ResponseEntity<InstallationResultDto> installationDtResult(List<InstallationResultForm> installationResultForms) throws Exception;

  ResponseEntity<InstallFailJobRequestDto> installDtFailJobRequest(InstallFailJobRequestForm installFailJobRequestForm) throws Exception;
}
