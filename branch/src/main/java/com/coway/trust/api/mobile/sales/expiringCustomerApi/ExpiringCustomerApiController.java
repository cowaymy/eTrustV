package com.coway.trust.api.mobile.sales.expiringCustomerApi;

import java.util.List;
import java.util.stream.Collectors;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.sales.expiringCustomerApi.ExpiringCustomerApiService;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;


/**
 * @ClassName : ExpiringCustomerApiController.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date             Author          Description
 * -------------    -----------     -------------
 * 2019. 12. 30.    KR-JAEMJAEM:)   First creation
 * </pre>
 */
@Api(value = "ExpiringCustomerApiController", description = "ExpiringCustomerApiController")
@RestController(value = "ExpiringCustomerApiController")
@RequestMapping(AppConstants.MOBILE_API_BASE_URI + "/expiringCustomerApi")
public class ExpiringCustomerApiController {



    private static final Logger LOGGER = LoggerFactory.getLogger(ExpiringCustomerApiController.class);



	@Resource(name = "ExpiringCustomerApiService")
	private ExpiringCustomerApiService expiringCustomerApiService;



	@ApiOperation(value = "selectExpiringCustomer", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/selectExpiringCustomer", method = RequestMethod.GET)
	public ResponseEntity<List<ExpiringCustomerApiDto>> selectExpiringCustomer(@ModelAttribute ExpiringCustomerApiForm param) throws Exception {
	    List<EgovMap> selectExpiringCustomer = expiringCustomerApiService.selectExpiringCustomer(param);
        if(LOGGER.isDebugEnabled()){
            for (int i = 0; i < selectExpiringCustomer.size(); i++) {
                LOGGER.debug("selectExpiringCustomer    값 : {}", selectExpiringCustomer.get(i));
            }
        }
        return ResponseEntity.ok(selectExpiringCustomer.stream().map(r -> ExpiringCustomerApiDto.create(r)).collect(Collectors.toList()));
	}



    @ApiOperation(value = "selectExpiringCustomerDetail", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    @RequestMapping(value = "/selectExpiringCustomerDetail", method = RequestMethod.GET)
    public ResponseEntity<ExpiringCustomerApiDto> selectExpiringCustomerDetail(@ModelAttribute ExpiringCustomerApiForm param) throws Exception {
        return ResponseEntity.ok(expiringCustomerApiService.selectExpiringCustomerDetail(param));
    }
}
