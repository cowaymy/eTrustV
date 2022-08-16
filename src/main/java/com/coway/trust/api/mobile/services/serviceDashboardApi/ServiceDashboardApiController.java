package com.coway.trust.api.mobile.services.serviceDashboardApi;

import java.util.List;
import java.util.stream.Collectors;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.services.serviceDashboardApi.ServiceDashboardApiService;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;


/**
 * @ClassName : ServiceDashboardApiController.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date             Author          Description
 * -------------    -----------     -------------
 * 2020.08.16		ALEX			MObile Services Dashboard Status
 * </pre>
 */
@Api(value = "ServiceDashboardApiController", description = "ServiceDashboardApiController")
@RestController(value = "ServiceDashboardApiController")
@RequestMapping(AppConstants.MOBILE_API_BASE_URI + "/serviceDashboardApi")
public class ServiceDashboardApiController {

	private static final Logger LOGGER = LoggerFactory.getLogger(ServiceDashboardApiController.class);

	@Resource(name = "ServiceDashboardApiService")
	private ServiceDashboardApiService serviceDashboardApiService;


	 @ApiOperation(value = "selectCsStatusDashboard", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
		@RequestMapping(value = "/selectCsStatusDashboard", method = RequestMethod.GET)
		public ResponseEntity<List<ServiceDashboardApiDto>> selectCsStatusDashboard(@ModelAttribute ServiceDashboardApiForm param) throws Exception {
			List<EgovMap> serviceCareDashboard = serviceDashboardApiService.selectCsStatusDashboard(param);
			if(LOGGER.isDebugEnabled()){
				for (int i = 0; i < serviceCareDashboard.size(); i++) {
					LOGGER.debug("selectCsStatusDashboard    값 : {}", serviceCareDashboard.get(i));
				}
			}
			return ResponseEntity.ok(serviceCareDashboard.stream().map(r -> ServiceDashboardApiDto.create(r)).collect(Collectors.toList()));
		}
}
