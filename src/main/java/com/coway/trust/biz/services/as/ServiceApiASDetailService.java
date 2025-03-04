package com.coway.trust.biz.services.as;

import java.util.Map;

import org.springframework.http.ResponseEntity;

import com.coway.trust.api.mobile.services.as.ASFailJobRequestDto;
import com.coway.trust.api.mobile.services.as.AfterServiceResultDto;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface ServiceApiASDetailService {
  EgovMap asResultProc( Map<String, Object> insApiresult ) throws Exception;

  ResponseEntity<ASFailJobRequestDto> asFailJobRequestProc( Map<String, Object> params ) throws Exception;

  ResponseEntity<AfterServiceResultDto> asDtResultProc( Map<String, Object> insApiresult ) throws Exception;
}
