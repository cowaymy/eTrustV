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
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.coway.trust.AppConstants;
import com.coway.trust.api.mobile.sales.eKeyInApi.EKeyInApiDto;
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
          LOGGER.debug("selectQuotationList : {}", selectQuotationist.get(i));
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
          LOGGER.debug("selectProductFilterList : {}", selectProductFilterList.get(i));
        }
      }
      return ResponseEntity.ok(selectProductFilterList.stream().map(r -> eSVMApiDto.create(r)).collect(Collectors.toList()));
    }

    @ApiOperation(value = "selectPackageFilter", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    @RequestMapping(value = "/selectPackageFilter", method = RequestMethod.GET)
    public ResponseEntity<eSVMApiDto> selectPackageFilter(@ModelAttribute eSVMApiForm param) throws Exception {
      return ResponseEntity.ok(eSVMApiService.selectPackageFilter(param));
    }

    @ApiOperation(value = "getPromoDisc", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    @RequestMapping(value = "/getPromoDisc", method = RequestMethod.GET)
    public ResponseEntity<eSVMApiDto> getPromoDisc(@ModelAttribute eSVMApiForm param) throws Exception {
      return ResponseEntity.ok(eSVMApiService.getPromoDisc(param));
    }

    @ApiOperation(value = "getFilterChargeSum", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    @RequestMapping(value = "/getFilterChargeSum", method = RequestMethod.GET)
    public ResponseEntity<eSVMApiDto> getFilterChargeSum(@ModelAttribute eSVMApiForm param) throws Exception {
      return ResponseEntity.ok(eSVMApiService.getFilterChargeSum(param));
    }

    @ApiOperation(value = "selectFilterList", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    @RequestMapping(value = "/selectFilterList", method = RequestMethod.GET)
    public ResponseEntity<List<eSVMApiDto>> selectFilterList(@ModelAttribute eSVMApiForm param) throws Exception {
      LOGGER.info("========== selectFilterList ==========");
      List<EgovMap> selectFilterList = eSVMApiService.selectFilterList(param);
      if (LOGGER.isDebugEnabled()) {
        for (int i = 0; i < selectFilterList.size(); i++) {
          LOGGER.debug("selectFilterList : {}", selectFilterList.get(i));
        }
      }
      return ResponseEntity.ok(selectFilterList.stream().map(r -> eSVMApiDto.create(r)).collect(Collectors.toList()));
    }

    @ApiOperation(value = "getOrderCurrentBillMonth", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    @RequestMapping(value = "/getOrderCurrentBillMonth", method = RequestMethod.GET)
    public ResponseEntity<eSVMApiDto> getOrderCurrentBillMonth(@ModelAttribute eSVMApiForm param) throws Exception {
      return ResponseEntity.ok(eSVMApiService.getOrderCurrentBillMonth(param));
    }

    @ApiOperation(value = "saveQuotationReq", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    @RequestMapping(value = "/saveQuotationReq", method = RequestMethod.POST)
    public ResponseEntity<eSVMApiDto> saveQuotationReq(@ModelAttribute eSVMApiForm param) throws Exception {
      return ResponseEntity.ok(eSVMApiService.saveQuotationReq(param));
    }

    @ApiOperation(value = "selectOrderMemInfo", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    @RequestMapping(value = "/selectOrderMemInfo", method = RequestMethod.GET)
    public ResponseEntity<eSVMApiDto> selectOrderMemInfo(@ModelAttribute eSVMApiForm param) throws Exception {
      return ResponseEntity.ok(eSVMApiService.selectOrderMemInfo(param));
    }
}
