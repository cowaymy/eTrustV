package com.coway.trust.api.mobile.sales.ccpApi;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.coway.trust.AppConstants;
import com.coway.trust.api.mobile.sales.customerApi.CustomerApiForm;
import com.coway.trust.biz.sales.ccpApi.PreCcpRegisterApiService;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;

/**
 * @ClassName : PreCcpRegisterApiController.java
 * @Description : TO-DO Class Description
 *
 */

@Api(value = "PreCcpRegisterApiController", description = "PreCcpRegisterApiController")
@RestController(value = "PreCcpRegisterApiController")
@RequestMapping(AppConstants.MOBILE_API_BASE_URI + "/ccpApi")
public class PreCcpRegisterApiController {

  private static final Logger LOGGER = LoggerFactory.getLogger(PreCcpRegisterApiController.class);

  @Resource(name = "PreCcpRegisterApiService")
  private PreCcpRegisterApiService preCcpRegisterApiService;

  @ApiOperation(value = "selectPreCcpRegisterList", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/selectPreCcpRegisterList", method = RequestMethod.GET)
  public ResponseEntity<List<PreCcpRegisterApiDto>> selectPreCcpRegisterList(@ModelAttribute PreCcpRegisterApiForm param) throws Exception {

	  List<EgovMap> selectPreCcpRegisterList = preCcpRegisterApiService.selectPreCcpRegisterList(param);

      if (LOGGER.isDebugEnabled()) {
          for (int i = 0; i < selectPreCcpRegisterList.size(); i++) {
            LOGGER.debug("selectPreCcpRegisterList    값 : {}", selectPreCcpRegisterList.get(i));
          }
      }

    return ResponseEntity.ok(selectPreCcpRegisterList.stream().map(r -> PreCcpRegisterApiDto.create(r)).collect(Collectors.toList()));
  }

  @ApiOperation(value = "savePreCcp", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/savePreCcp", method = RequestMethod.POST)
  public ResponseEntity<PreCcpRegisterApiForm> saveCustomer(@RequestBody PreCcpRegisterApiForm param) throws Exception {
    return ResponseEntity.ok(preCcpRegisterApiService.savePreCcp(param));
  }





}
