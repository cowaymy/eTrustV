package com.coway.trust.web.common;

/**************************************
 * Author                  Date                    Remark
 * Chew Kah Kit        2019/04/11           API for customer portal
 ***************************************/

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.biz.common.ApiService;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/api")
public class ApiController {

  private static final Logger LOGGER = LoggerFactory.getLogger(ApiController.class);

  @Resource(name = "apiService")
  private ApiService apiService;

  @RequestMapping(value = "/customer/getCowayCustByNricOrPassport.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> getCowayCustByNricOrPassport(HttpServletRequest request,@RequestParam Map<String, Object> params) {
    EgovMap cowayCustDetails = apiService.selectCowayCustNricOrPassport(request, params);
    return ResponseEntity.ok(cowayCustDetails);
  }

}
