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
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.coway.trust.AppConstants;
import com.coway.trust.api.mobile.common.files.FileDto;
import com.coway.trust.api.mobile.sales.eSVM.eSVMApiDto;
import com.coway.trust.api.mobile.sales.eSVM.eSVMApiForm;
import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.sales.eSVM.eSVMApiService;
import com.coway.trust.cmmn.file.EgovFileUploadUtil;
import com.coway.trust.util.EgovFormBasedFileVo;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import springfox.documentation.annotations.ApiIgnore;

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
    @RequestMapping(value = "/saveQuotationReq", method = RequestMethod.GET)
    public ResponseEntity<eSVMApiDto> saveQuotationReq(@ModelAttribute eSVMApiForm param) throws Exception {
      return ResponseEntity.ok(eSVMApiService.saveQuotationReq(param));
    }

    @ApiOperation(value = "selectOrderMemInfo", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    @RequestMapping(value = "/selectOrderMemInfo", method = RequestMethod.GET)
    public ResponseEntity<eSVMApiDto> selectOrderMemInfo(@ModelAttribute eSVMApiForm param) throws Exception {
      return ResponseEntity.ok(eSVMApiService.selectOrderMemInfo(param));
    }

    @ApiOperation(value = "cancelSMQ", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    @RequestMapping(value = "/cancelSMQ", method = RequestMethod.POST)
    public ResponseEntity<eSVMApiDto> cancelSMQ(@RequestBody eSVMApiForm param) throws Exception {
      return ResponseEntity.ok(eSVMApiService.cancelSMQ(param));
    }

    @ApiOperation(value = "insertUploadPaymentFile", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    @RequestMapping(value = "/insertUploadPaymentFile", method = RequestMethod.GET)
    public ResponseEntity<FileDto> insertUploadPaymentFile(@ApiIgnore MultipartHttpServletRequest request, @ModelAttribute eSVMApiDto param) throws Exception {
        LOGGER.debug("eSVMApiController :: insertUploadPaymentFile");
        List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles(request, webUploadDir, param.getSubPath(), AppConstants.UPLOAD_MIN_FILE_SIZE, true);

        int fileGroupKey = eSVMApiService.insertUploadPaymentFile(FileVO.createList(list), param);
        FileDto fileDto = FileDto.create(list, fileGroupKey);
        return ResponseEntity.ok(fileDto);
    }

    @ApiOperation(value = "insertPSM", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    @RequestMapping(value = "/insertPSM", method = RequestMethod.POST)
    public ResponseEntity<eSVMApiDto> insertPSM(@RequestBody eSVMApiForm param) throws Exception {
        LOGGER.debug("eSVMApiController :: insertPSM");
        return ResponseEntity.ok(eSVMApiService.insertPSM(param));
    }

    @ApiOperation(value = "selectPSMList", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    @RequestMapping(value = "/selectPSMList", method = RequestMethod.GET)
    public ResponseEntity<List<eSVMApiDto>> selectPSMList(@ModelAttribute eSVMApiForm param) throws Exception {
      List<EgovMap> selectPSMList = eSVMApiService.selectPSMList(param);
      if (LOGGER.isDebugEnabled()) {
        for (int i = 0; i < selectPSMList.size(); i++) {
          LOGGER.debug("selectQuotationList : {}", selectPSMList.get(i));
        }
      }
      return ResponseEntity.ok(selectPSMList.stream().map(r -> eSVMApiDto.create(r)).collect(Collectors.toList()));
    }

    @ApiOperation(value = "selectPsmAttachment", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    @RequestMapping(value = "/selectPsmAttachment", method = RequestMethod.GET)
    public ResponseEntity<List<eSVMApiDto>> selectESvmAttachment(@ModelAttribute eSVMApiForm param) throws Exception {
      List<EgovMap> svmAttachmentList = eSVMApiService.selectESvmAttachment(param);
      if (LOGGER.isDebugEnabled()) {
        for (int i = 0; i < svmAttachmentList.size(); i++) {
          LOGGER.debug("selectPsmAttachment : {}", svmAttachmentList.get(i));
        }
      }
      return ResponseEntity.ok(svmAttachmentList.stream().map(r -> eSVMApiDto.create(r)).collect(Collectors.toList()));
    }

    @ApiOperation(value = "removePsmAttachment", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    @RequestMapping(value = "/removePsmAttachment", method = RequestMethod.POST)
    public ResponseEntity<eSVMApiDto> removePsmAttachment(@RequestBody eSVMApiForm param) throws Exception {
        LOGGER.debug("eSVMApiController :: removePsmAttachment");
        return ResponseEntity.ok(eSVMApiService.removePsmAttachment(param));
    }

    @ApiOperation(value = "updatePaymentUploadFile", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    @RequestMapping(value = "/updatePaymentUploadFile", method = RequestMethod.POST)
    public ResponseEntity<FileDto> updatePaymentUploadFile(@ApiIgnore MultipartHttpServletRequest request, @ModelAttribute eSVMApiDto param) throws Exception {
        LOGGER.debug("*************************************************************************************************************");
        LOGGER.debug("***************************************updatePaymentUploadFile***********************************************");
        LOGGER.debug("*************************************************************************************************************");
        List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles(request, webUploadDir, param.getSubPath(), AppConstants.UPLOAD_MIN_FILE_SIZE, true);

        int fileGroupKey = eSVMApiService.updatePaymentUploadFile(FileVO.createList(list), param);
        FileDto fileDto = FileDto.create(list, fileGroupKey);
        return ResponseEntity.ok(fileDto);
    }

    @ApiOperation(value = "updatePaymentUploadFile_1", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    @RequestMapping(value = "/updatePaymentUploadFile_1", method = RequestMethod.POST)
    public ResponseEntity<eSVMApiDto> updatePaymentUploadFile_1(@RequestBody eSVMApiForm param) throws Exception {
        LOGGER.debug("eSVMApiController :: insertPSM");
        return ResponseEntity.ok(eSVMApiService.updatePaymentUploadFile_1(param));
    }

    @ApiOperation(value = "getMemberLevel", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    @RequestMapping(value = "/getMemberLevel", method = RequestMethod.GET)
    public ResponseEntity<eSVMApiDto> selectMemberLevel(@ModelAttribute eSVMApiForm param) throws Exception {
      return ResponseEntity.ok(eSVMApiService.getMemberLevel(param));
    }

    @ApiOperation(value = "selectEosEomDt", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    @RequestMapping(value = "/selectEosEomDt", method = RequestMethod.GET)
    public ResponseEntity<eSVMApiDto> selectEosEomDt(@ModelAttribute eSVMApiForm param) throws Exception {
    	LOGGER.debug("eSVMApiController :: selectEosEomDt");
    	LOGGER.debug("param :: " + param);
      return ResponseEntity.ok(eSVMApiService.selectEosEomDt(param));
    }
}
