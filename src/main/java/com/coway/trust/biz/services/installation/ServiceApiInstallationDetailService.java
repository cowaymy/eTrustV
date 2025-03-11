package com.coway.trust.biz.services.installation;

import java.util.Map;

import org.springframework.http.ResponseEntity;

import com.coway.trust.api.mobile.services.installation.InstallationResultDto;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface ServiceApiInstallationDetailService {
  ResponseEntity<InstallationResultDto> installationResultProc(Map<String, Object> insApiresult) throws Exception;

  EgovMap installFailJobRequestProc(Map<String, Object> params) throws Exception;

  ResponseEntity<InstallationResultDto> installationDtResultProc(Map<String, Object> insApiresult) throws Exception;

  //void installationResultProcSendEmail(Map<String, Object> params);
}
