package com.coway.trust.api.mobile.sales.addressApi;

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
import com.coway.trust.biz.sales.addressApi.AddressApiService;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;


/**
 * @ClassName : AddressApiController.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date             Author          Description
 * -------------    -----------     -------------
 * 2019. 09. 24.    KR-JAEMJAEM:)   First creation
 * </pre>
 */
@Api(value = "AddressApiController", description = "AddressApiController")
@RestController(value = "AddressApiController")
@RequestMapping(AppConstants.MOBILE_API_BASE_URI + "/addressApi")
public class AddressApiController {



	private static final Logger LOGGER = LoggerFactory.getLogger(AddressApiController.class);



	@Resource(name = "AddressApiService")
	private AddressApiService addressApiService;



	@ApiOperation(value = "selectStateCodeList", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/selectStateCodeList", method = RequestMethod.GET)
	public ResponseEntity<List<AddressApiDto>> selectStateCodeList(@ModelAttribute AddressApiForm param) throws Exception {
		List<EgovMap> selectStateCodeList = addressApiService.selectStateCodeList(param);
		if(LOGGER.isDebugEnabled()){
			for (int i = 0; i < selectStateCodeList.size(); i++) {
				LOGGER.debug("selectStateCodeList    값 : {}", selectStateCodeList.get(i));
			}
		}
		return ResponseEntity.ok(selectStateCodeList.stream().map(r -> AddressApiDto.create(r)).collect(Collectors.toList()));
	}



    @ApiOperation(value = "selectCityCodeList", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    @RequestMapping(value = "/selectCityCodeList", method = RequestMethod.GET)
    public ResponseEntity<List<AddressApiDto>> selectCityCodeList(@ModelAttribute AddressApiForm param) throws Exception {
        List<EgovMap> selectCityCodeList = addressApiService.selectCityCodeList(param);
        if(LOGGER.isDebugEnabled()){
            for (int i = 0; i < selectCityCodeList.size(); i++) {
                LOGGER.debug("selectCityCodeList    값 : {}", selectCityCodeList.get(i));
            }
        }
        return ResponseEntity.ok(selectCityCodeList.stream().map(r -> AddressApiDto.create(r)).collect(Collectors.toList()));
    }


    @ApiOperation(value = "selectPostcodeList", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    @RequestMapping(value = "/selectPostcodeList", method = RequestMethod.GET)
    public ResponseEntity<List<AddressApiDto>> selectPostcodeList(@ModelAttribute AddressApiForm param) throws Exception {
        List<EgovMap> selectPostcodeList = addressApiService.selectPostcodeList(param);
        if(LOGGER.isDebugEnabled()){
            for (int i = 0; i < selectPostcodeList.size(); i++) {
                LOGGER.debug("selectPostcodeList    값 : {}", selectPostcodeList.get(i));
            }
        }
        return ResponseEntity.ok(selectPostcodeList.stream().map(r -> AddressApiDto.create(r)).collect(Collectors.toList()));
    }


    @ApiOperation(value = "selectAreaList", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    @RequestMapping(value = "/selectAreaList", method = RequestMethod.GET)
    public ResponseEntity<List<AddressApiDto>> selectAreaList(@ModelAttribute AddressApiForm param) throws Exception {
        List<EgovMap> selectAreaList = addressApiService.selectAreaList(param);
        if(LOGGER.isDebugEnabled()){
            for (int i = 0; i < selectAreaList.size(); i++) {
                LOGGER.debug("selectAreaList    값 : {}", selectAreaList.get(i));
            }
        }
        return ResponseEntity.ok(selectAreaList.stream().map(r -> AddressApiDto.create(r)).collect(Collectors.toList()));
    }


    @ApiOperation(value = "selectAddressList", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    @RequestMapping(value = "/selectAddressList", method = RequestMethod.GET)
    public ResponseEntity<List<AddressApiDto>> selectAddressList(@ModelAttribute AddressApiForm param) throws Exception {
        List<EgovMap> selectAddressList = addressApiService.selectAddressList(param);
        if(LOGGER.isDebugEnabled()){
            for (int i = 0; i < selectAddressList.size(); i++) {
                LOGGER.debug("selectAddressList    값 : {}", selectAddressList.get(i));
            }
        }
        return ResponseEntity.ok(selectAddressList.stream().map(r -> AddressApiDto.create(r)).collect(Collectors.toList()));
    }
}
