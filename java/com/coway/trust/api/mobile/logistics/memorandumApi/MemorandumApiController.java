package com.coway.trust.api.mobile.logistics.memorandumApi;

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
import com.coway.trust.biz.logistics.memorandumApi.MemorandumApiService;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;

/**
 * @ClassName : MemorandumApiController.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date             Author          Description
 * -------------    -----------     -------------
 * 2019. 09. 05.    KR-JAEMJAEM:)   First creation
 * </pre>
 */
@Api(value = "MemorandumApiController", description = "MemorandumApiController")
@RestController(value = "MemorandumApiController")
@RequestMapping(AppConstants.MOBILE_API_BASE_URI + "/memorandumApi")
public class MemorandumApiController {



	private static final Logger LOGGER = LoggerFactory.getLogger(MemorandumApiController.class);



	@Resource(name = "MemorandumApiService")
	private MemorandumApiService memorandumApiService;



    @ApiOperation(value = "selectMemorandumList", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    @RequestMapping(value = "/selectMemorandumList", method = RequestMethod.GET)
    public ResponseEntity<List<MemorandumApiDto>> selectMemorandumList(@ModelAttribute MemorandumApiFormDto param) throws Exception {
        List<EgovMap> selectMemorandumList = memorandumApiService.selectMemorandumList( param );
        if(LOGGER.isDebugEnabled()){
            for (int i = 0; i < selectMemorandumList.size(); i++) {
                    LOGGER.debug("selectMemorandumList    값 : {}", selectMemorandumList.get(i));
            }
        }
        return ResponseEntity.ok(selectMemorandumList.stream().map(r -> MemorandumApiDto.create(r)).collect(Collectors.toList()));
    }
}