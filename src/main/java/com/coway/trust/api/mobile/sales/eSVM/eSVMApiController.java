package com.coway.trust.api.mobile.sales.eSVM;

import java.util.List;
import java.util.stream.Collectors;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.coway.trust.AppConstants;
import com.coway.trust.api.mobile.sales.eSVM.eSVMApiDto;
import com.coway.trust.api.mobile.sales.eSVM.eSVMApiForm;
import com.coway.trust.biz.sales.eSVM.eSVMApiService;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;

@Api(value = "eSVMApiController", description = "eSVMApiController")
@RestController(value = "eSVMApiController")
@RequestMapping(AppConstants.MOBILE_API_BASE_URI + "/eSVMApi")
public class eSVMApiController {

    private static final Logger LOGGER = LoggerFactory.getLogger(eSVMApiController.class);

    @Resource(name = "eSVMApiService")
    private eSVMApiService eSVMApiService;

    @Value("${web.resource.upload.file}")
    private String webUploadDir;

    @ApiOperation(value = "selectQuotationList", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    @RequestMapping(value = "/selectQuotationList", method = RequestMethod.GET)
    public ResponseEntity<List<eSVMApiDto>> selecteQuotationist(@ModelAttribute eSVMApiForm param) throws Exception {
      List<EgovMap> selectQuotationist = eSVMApiService.selectQuotationList(param);
      if (LOGGER.isDebugEnabled()) {
        for (int i = 0; i < selectQuotationist.size(); i++) {
          LOGGER.debug("selecteQuotationist : {}", selectQuotationist.get(i));
        }
      }
      return ResponseEntity.ok(selectQuotationist.stream().map(r -> eSVMApiDto.create(r)).collect(Collectors.toList()));
    }

    @ApiOperation(value = "selectSvmOrdNo", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    @RequestMapping(value = "/selectSvmOrdNo", method = RequestMethod.GET)
    public ResponseEntity<eSVMApiDto> selectSvmOrdNo(@ModelAttribute eSVMApiForm param) throws Exception {
      return ResponseEntity.ok(eSVMApiService.selectSvmOrdNo(param));
    }

    @ApiOperation(value = "selectProductFilterList", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    @RequestMapping(value = "/selectProductFilterList", method = RequestMethod.GET)
    public ResponseEntity<List<eSVMApiDto>> selectProductFilterList(@ModelAttribute eSVMApiForm param) throws Exception {
      LOGGER.info("========== selectProductFilterList ==========");
      List<EgovMap> selectProductFilterList = eSVMApiService.selectProductFilterList(param);
      if (LOGGER.isDebugEnabled()) {
        for (int i = 0; i < selectProductFilterList.size(); i++) {
          LOGGER.debug("selecteKeyInList    값 : {}", selectProductFilterList.get(i));
        }
      }
      return ResponseEntity.ok(selectProductFilterList.stream().map(r -> eSVMApiDto.create(r)).collect(Collectors.toList()));
    }

    @ApiOperation(value = "selectOrderMemInfo", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    @RequestMapping(value = "/selectOrderMemInfo", method = RequestMethod.GET)
    public ResponseEntity<eSVMApiDto> selectOrderMemInfo(@ModelAttribute eSVMApiForm param) throws Exception {
      return ResponseEntity.ok(eSVMApiService.selectOrderMemInfo(param));
    }
}
