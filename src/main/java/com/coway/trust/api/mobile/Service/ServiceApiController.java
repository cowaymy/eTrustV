package com.coway.trust.api.mobile.Service;

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
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.coway.trust.AppConstants;
import com.coway.trust.api.mobile.Service.as.AfterServiceJobDto;
import com.coway.trust.api.mobile.Service.as.AfterServiceJobForm;
import com.coway.trust.api.mobile.Service.heartService.HeartServiceJobDto;
import com.coway.trust.api.mobile.Service.heartService.HeartServiceJobForm;
import com.coway.trust.biz.services.mlog.MSvcLogApiService;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;


@Api(value = "service api", description = "service api")
@RestController(value = "serviceApiController")
@RequestMapping(AppConstants.MOBILE_API_BASE_URI + "/service")
public class ServiceApiController {
	private static final Logger LOGGER = LoggerFactory.getLogger(ServiceApiController.class);
	
	@Resource(name = "MSvcLogApiService")
	private MSvcLogApiService MSvcLogApiService;

	@Autowired
	private MessageSourceAccessor messageAccessor;
	
	
	
	@ApiOperation(value = "Heart Service Job List 조회", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/heartServiceJobList", method = RequestMethod.GET)
	public ResponseEntity<List<HeartServiceJobDto>> getHeartServiceJob(
			@ModelAttribute HeartServiceJobForm HeartServiceJobForm) throws Exception {

		Map<String, Object> params = HeartServiceJobForm.createMap(HeartServiceJobForm);

		List<EgovMap> HeartServiceJobList = MSvcLogApiService.getHeartServiceJobList(params);

		for (int i = 0; i < HeartServiceJobList.size(); i++) {
			LOGGER.debug("HeartServiceJobList    값 : {}", HeartServiceJobList.get(i));

		}
		
		List<HeartServiceJobDto> list = HeartServiceJobList.stream().map(r -> HeartServiceJobDto.create(r))
				.collect(Collectors.toList());

		return ResponseEntity.ok(list);
	}
	
	
	
	
	
	@ApiOperation(value = "AfterServiceJob List 조회", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/AfterServiceJobList", method = RequestMethod.GET)
	public ResponseEntity<List<AfterServiceJobDto>> getHeartServiceJob(
			@ModelAttribute AfterServiceJobForm AfterServiceJobForm) throws Exception {

		Map<String, Object> params = AfterServiceJobForm.createMap(AfterServiceJobForm);

		List<EgovMap> AfterServiceJobList = MSvcLogApiService.getAfterServiceJobList(params);

		for (int i = 0; i < AfterServiceJobList.size(); i++) {
			LOGGER.debug("AfterServiceJobList    값 : {}", AfterServiceJobList.get(i));

		}
		
		List<AfterServiceJobDto> list = AfterServiceJobList.stream().map(r -> AfterServiceJobDto.create(r))
				.collect(Collectors.toList());

		return ResponseEntity.ok(list);
	}
	
	
	

}
