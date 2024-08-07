package com.coway.trust.api.mobile.payment.cashMatching;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.payment.payment.service.CashMatchingApiService;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;

/**
/**
 * @ClassName : CashMatchingApiController.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 10. 19.   KR-HAN        First creation
 * </pre>
 */
@Api(value = "CashMatching Api", description = "CashMatching Api")
@RestController(value = "cashMatchingApiController")
@RequestMapping(AppConstants.MOBILE_API_BASE_URI + "/cashMatching")
public class CashMatchingApiController {
  
  private static final Logger LOGGER = LoggerFactory.getLogger(CashMatchingApiController.class);
  
  @Resource(name = "cashMatchingApiService")
  private CashMatchingApiService cashMatchingApiService;
  
  @Autowired
  private MessageSourceAccessor messageAccessor;
  
  /**
   * TO-DO Description
   * 
   * @Author KR-HAN
   * @Date 2019. 10. 19.
   * @param cashMatchingForm
   * @return
   * @throws Exception
   */
  @ApiOperation(value = "Cash Matching", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/selectCashMatching", method = RequestMethod.GET)
  public ResponseEntity<List<CashMatchingDto>> selectCashMatching(@ModelAttribute CashMatchingForm cashMatchingForm)
      throws Exception {
    
    Map<String, Object> params = cashMatchingForm.createMap(cashMatchingForm);
    List<EgovMap> selectCashMatching = null;
    
    // 즈믄 조회
    selectCashMatching = cashMatchingApiService.selectCashMatching(params);
    
    List<CashMatchingDto> cashMatching = selectCashMatching.stream().map(r -> CashMatchingDto.create(r))
        .collect(Collectors.toList());
    
    return ResponseEntity.ok(cashMatching);
  }
  
  /**
   * TO-DO Description
   * 
   * @Author KR-HAN
   * @Date 2019. 10. 19.
   * @param cashMatchingForm
   * @throws Exception
   */
  @ApiOperation(value = "Save Cash Matching", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/saveCashMatching", method = RequestMethod.POST)
  public void saveCashMatching(@RequestBody List<CashMatchingForm> cashMatchingForm) throws Exception {
    
    cashMatchingApiService.saveCashMatching(cashMatchingForm);
  }
  
}
