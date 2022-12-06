package com.coway.trust.api.mobile.sales.customerApi;

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
import com.coway.trust.biz.sales.customerApi.CustomerApiService;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;

/**
 * @ClassName : CustomerApiController.java
 * @Description : TO-DO Class Description
 *
 * @History
 *
 *          <pre>
 * Date             Author          Description
 * -------------    -----------     -------------
 * 2019. 09. 16.    KR-JAEMJAEM:)   First creation
 * 2020. 04. 14.    MY-ONGHC         Restructure Messy Code
 *          </pre>
 */
@Api(value = "CustomerApiController", description = "CustomerApiController")
@RestController(value = "CustomerApiController")
@RequestMapping(AppConstants.MOBILE_API_BASE_URI + "/customerApi")
public class CustomerApiController {

  private static final Logger LOGGER = LoggerFactory.getLogger(CustomerApiController.class);

  @Resource(name = "CustomerApiService")
  private CustomerApiService customerApiService;

  @ApiOperation(value = "selectCustomerList", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/selectCustomerList", method = RequestMethod.GET)
  public ResponseEntity<List<CustomerApiDto>> selectCustomerList(@ModelAttribute CustomerApiForm param)
      throws Exception {
    List<EgovMap> selectCustomerList = customerApiService.selectCustomerList(param);
    if (LOGGER.isDebugEnabled()) {
      for (int i = 0; i < selectCustomerList.size(); i++) {
        LOGGER.debug("selectCustomerList    값 : {}", selectCustomerList.get(i));
      }
    }
    return ResponseEntity.ok(selectCustomerList.stream().map(r -> CustomerApiDto.create(r)).collect(Collectors.toList()));
  }

  @ApiOperation(value = "selectCustomerInfo", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/selectCustomerInfo", method = RequestMethod.GET)
  public ResponseEntity<CustomerApiDto> selectCustomerInfo(@ModelAttribute CustomerApiForm param) throws Exception {
    return ResponseEntity.ok(CustomerApiDto.create(customerApiService.selectCustomerInfo(param)));
  }

  @ApiOperation(value = "selectCustomerOrder", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/selectCustomerOrder", method = RequestMethod.GET)
  public ResponseEntity<List<CustomerApiDto>> selectCustomerOrder(@ModelAttribute CustomerApiForm param)
      throws Exception {
    List<EgovMap> selectCustomerOrder = customerApiService.selectCustomerOrder(param);
    if (LOGGER.isDebugEnabled()) {
      for (int i = 0; i < selectCustomerOrder.size(); i++) {
        LOGGER.debug("selectCustomerOrder    값 : {}", selectCustomerOrder.get(i));
      }
    }
    return ResponseEntity
        .ok(selectCustomerOrder.stream().map(r -> CustomerApiDto.create(r)).collect(Collectors.toList()));
  }

  @ApiOperation(value = "selectCodeList", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/selectCodeList", method = RequestMethod.GET)
  public ResponseEntity<CustomerApiDto> selectCodeList() throws Exception {
    return ResponseEntity.ok(customerApiService.selectCodeList());
  }

  @ApiOperation(value = "saveCustomer", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/saveCustomer", method = RequestMethod.POST)
  public ResponseEntity<CustomerApiForm> saveCustomer(@RequestBody CustomerApiForm param) throws Exception {
    return ResponseEntity.ok(customerApiService.saveCustomer(param));
  }

  @ApiOperation(value = "convertDate", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/convertDate", method = RequestMethod.GET)
  public ResponseEntity<CustomerApiForm> convertDate(@ModelAttribute CustomerApiForm param) throws Exception {
    CustomerApiForm rtn = new CustomerApiForm();
    try {
      String date = param.getYymmdd();

      SimpleDateFormat sdf1 = new SimpleDateFormat("yyMMdd");
      Date d1 = sdf1.parse(date);
      sdf1.applyPattern("dd/MM/yyyy");
      rtn.setDdmmyyyy(sdf1.format(d1));

      SimpleDateFormat sdf2 = new SimpleDateFormat("yyMMdd");
      Date d2 = sdf2.parse(date);
      sdf2.applyPattern("yyyyMMdd");
      rtn.setYyyymmdd(sdf2.format(d2));

      if (LOGGER.isDebugEnabled()) {
        LOGGER.debug("yymmdd     :::>>> " + param.getYymmdd());
        LOGGER.debug("dd/MM/yyyy :::>>> " + rtn.getDdmmyyyy());
        LOGGER.debug("yyyyMMdd   :::>>> " + rtn.getYyyymmdd());
      }
    } catch (Exception e) {
      rtn.setDdmmyyyy("");
      rtn.setYyyymmdd("");
      if (LOGGER.isErrorEnabled()) {
        LOGGER.equals("Exception : " + e.toString());
      }
    }
    return ResponseEntity.ok(rtn);
  }

  @ApiOperation(value = "selectCustomerTierPoint", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/selectCustomerTierPoint", method = RequestMethod.GET)
  public ResponseEntity<Map<String, Object>> selectCustomerTierPoint(HttpServletRequest request,@ModelAttribute CustomerApiForm param)
      throws Exception {
	  Map<String, Object> tierFullDetails = new HashMap<String, Object>();
	  tierFullDetails = customerApiService.selectCustomerTierPoint(request,param);
      if (LOGGER.isDebugEnabled()) {
       LOGGER.debug("selectCustomerfulldetails    값 : {}", tierFullDetails);
      }
    return ResponseEntity.ok(tierFullDetails);
  }
}
