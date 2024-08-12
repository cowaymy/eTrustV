package com.coway.trust.api.mobile.sales.eKeyInApi;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.net.URLEncoder;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.coway.trust.AppConstants;
import com.coway.trust.api.mobile.common.files.FileDto;
import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.sales.eKeyInApi.EKeyInApiService;
import com.coway.trust.cmmn.exception.FileDownException;
import com.coway.trust.cmmn.file.EgovFileUploadUtil;
import com.coway.trust.util.EgovBasicLogger;
import com.coway.trust.util.EgovFormBasedFileVo;
import com.coway.trust.util.EgovResourceCloseHelper;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import springfox.documentation.annotations.ApiIgnore;

/**
 * @ClassName : EKeyInListApiController.java
 * @Description : TO-DO Class Description
 *
 * @HistoryselectAnotherContact
 *
 *                              <pre>
 *                              Date Author Description
 *                              ------------- ----------- -------------
 *                              2019. 12. 09. KR-JAEMJAEM:) First creation
 *                              2020. 04. 08. MY-ONGHC Add selectCpntLst to Retrieve Component List
 *                              Add selectPromoByCpntId
 *                              2023. 06. 27. MY-ONGHC Add checkTNA for Validate Card Validity bt crcID
 *                              </pre>
 */
@Api(value = "EKeyInListApiController", description = "EKeyInListApiController")
@RestController(value = "EKeyInListApiController")
@RequestMapping(AppConstants.MOBILE_API_BASE_URI + "/eKeyInApi")
public class EKeyInApiController {

  private static final Logger LOGGER = LoggerFactory.getLogger(EKeyInApiController.class);

  @Resource(name = "EKeyInApiService")
  private EKeyInApiService eKeyInApiService;

  @Value("${web.resource.upload.file}")
  private String webUploadDir;

  @ApiOperation(value = "selecteKeyInList", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/selecteKeyInList", method = RequestMethod.GET)
  public ResponseEntity<List<EKeyInApiDto>> selecteKeyInList(@ModelAttribute EKeyInApiForm param) throws Exception {
    List<EgovMap> selecteKeyInList = eKeyInApiService.selecteKeyInList(param);
    if (LOGGER.isDebugEnabled()) {
      for (int i = 0; i < selecteKeyInList.size(); i++) {
        LOGGER.debug("selecteKeyInList    값 : {}", selecteKeyInList.get(i));
      }
    }
    return ResponseEntity.ok(selecteKeyInList.stream().map(r -> EKeyInApiDto.create(r)).collect(Collectors.toList()));
  }

  @ApiOperation(value = "selectCodeList", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/selectCodeList", method = RequestMethod.GET)
  public ResponseEntity<EKeyInApiDto> selectCodeList() throws Exception {
    return ResponseEntity.ok(eKeyInApiService.selectCodeList());
  }

  @ApiOperation(value = "selecteKeyInDetail", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/selecteKeyInDetail", method = RequestMethod.GET)
  public ResponseEntity<EKeyInApiDto> selecteKeyInDetail(@ModelAttribute EKeyInApiForm param) throws Exception {
    return ResponseEntity.ok(eKeyInApiService.selecteKeyInDetail(param));
  }

  @ApiOperation(value = "selecteOrderPackType1", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/selecteOrderPackType1", method = RequestMethod.GET)
  public ResponseEntity<List<EKeyInApiDto>> selecteOrderPackType1() throws Exception {
    List<EgovMap> selecteOrderPackType1 = eKeyInApiService.selecteOrderPackType1();
    if (LOGGER.isDebugEnabled()) {
      for (int i = 0; i < selecteOrderPackType1.size(); i++) {
        LOGGER.debug("selecteOrderPackType1    값 : {}", selecteOrderPackType1.get(i));
      }
    }
    return ResponseEntity.ok(selecteOrderPackType1.stream().map(r -> EKeyInApiDto.create(r)).collect(Collectors.toList()));
  }

  @ApiOperation(value = "selecteOrderPackType2", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/selecteOrderPackType2", method = RequestMethod.GET)
  public ResponseEntity<List<EKeyInApiDto>> selecteOrderPackType2(@ModelAttribute EKeyInApiForm param) throws Exception {
    List<EgovMap> selecteOrderPackType2 = eKeyInApiService.selecteOrderPackType2(param);
    if (LOGGER.isDebugEnabled()) {
      for (int i = 0; i < selecteOrderPackType2.size(); i++) {
        LOGGER.debug("selecteOrderPackType2    값 : {}", selecteOrderPackType2.get(i));
      }
    }
    return ResponseEntity.ok(selecteOrderPackType2.stream().map(r -> EKeyInApiDto.create(r)).collect(Collectors.toList()));
  }

  @ApiOperation(value = "selecteOrderProduct1", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/selecteOrderProduct1", method = RequestMethod.GET)
  public ResponseEntity<List<EKeyInApiDto>> selecteOrderProduct1(EKeyInApiForm param) throws Exception {
    List<EgovMap> selecteOrderProduct1 = eKeyInApiService.selecteOrderProduct1(param);
    if (LOGGER.isDebugEnabled()) {
      for (int i = 0; i < selecteOrderProduct1.size(); i++) {
        LOGGER.debug("selecteOrderProduct1    값 : {}", selecteOrderProduct1.get(i));
      }
    }
    return ResponseEntity.ok(selecteOrderProduct1.stream().map(r -> EKeyInApiDto.create(r)).collect(Collectors.toList()));
  }

  @ApiOperation(value = "selecteOrderProduct2", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/selecteOrderProduct2", method = RequestMethod.GET)
  public ResponseEntity<List<EKeyInApiDto>> selecteOrderProduct2(EKeyInApiForm param) throws Exception {
    List<EgovMap> selecteOrderProduct2 = eKeyInApiService.selecteOrderProduct2(param);
    if (LOGGER.isDebugEnabled()) {
      for (int i = 0; i < selecteOrderProduct2.size(); i++) {
        LOGGER.debug("selecteOrderProduct2    값 : {}", selecteOrderProduct2.get(i));
      }
    }
    return ResponseEntity.ok(selecteOrderProduct2.stream().map(r -> EKeyInApiDto.create(r)).collect(Collectors.toList()));
  }

  @ApiOperation(value = "selectPromotionByAppTypeStockESales", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/selectPromotionByAppTypeStockESales", method = RequestMethod.GET)
  public ResponseEntity<List<EKeyInApiDto>> selectPromotionByAppTypeStockESales(@ModelAttribute EKeyInApiForm param) throws Exception {
    List<EgovMap> selectPromotionByAppTypeStockESales = eKeyInApiService.selectPromotionByAppTypeStockESales(param);
    if (LOGGER.isDebugEnabled()) {
      for (int i = 0; i < selectPromotionByAppTypeStockESales.size(); i++) {
        LOGGER.debug("selectPromotionByAppTypeStockESales    값 : {}", selectPromotionByAppTypeStockESales.get(i));
      }
    }
    return ResponseEntity.ok(selectPromotionByAppTypeStockESales.stream().map(r -> EKeyInApiDto.create(r)).collect(Collectors.toList()));
  }

  @ApiOperation(value = "selectPromotionByAppTypeStock", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/selectPromotionByAppTypeStock", method = RequestMethod.GET)
  public ResponseEntity<List<EKeyInApiDto>> selectPromotionByAppTypeStock(@ModelAttribute EKeyInApiForm param) throws Exception {
    List<EgovMap> selectPromotionByAppTypeStock = eKeyInApiService.selectPromotionByAppTypeStock(param);
    if (LOGGER.isDebugEnabled()) {
      for (int i = 0; i < selectPromotionByAppTypeStock.size(); i++) {
        LOGGER.debug("selectPromotionByAppTypeStock    값 : {}", selectPromotionByAppTypeStock.get(i));
      }
    }
    return ResponseEntity.ok(selectPromotionByAppTypeStock.stream().map(r -> EKeyInApiDto.create(r)).collect(Collectors.toList()));
  }

  @ApiOperation(value = "selectBankList", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/selectBankList", method = RequestMethod.GET)
  public ResponseEntity<List<EKeyInApiDto>> selectBankList() throws Exception {
    List<EgovMap> selectBankList = eKeyInApiService.selectBankList();
    if (LOGGER.isDebugEnabled()) {
      for (int i = 0; i < selectBankList.size(); i++) {
        LOGGER.debug("selectBankList    값 : {}", selectBankList.get(i));
      }
    }
    return ResponseEntity.ok(selectBankList.stream().map(r -> EKeyInApiDto.create(r)).collect(Collectors.toList()));
  }

  @ApiOperation(value = "selectAnotherContact", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/selectAnotherContact", method = RequestMethod.GET)
  public ResponseEntity<List<EKeyInApiDto>> selectAnotherContact(EKeyInApiForm param) throws Exception {
    List<EgovMap> selectAnotherContact = eKeyInApiService.selectAnotherContact(param);
    if (LOGGER.isDebugEnabled()) {
      for (int i = 0; i < selectAnotherContact.size(); i++) {
        LOGGER.debug("selectAnotherContact    값 : {}", selectAnotherContact.get(i));
      }
    }
    return ResponseEntity.ok(selectAnotherContact.stream().map(r -> EKeyInApiDto.create(r)).collect(Collectors.toList()));
  }

  @ApiOperation(value = "saveAddNewContact", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/saveAddNewContact", method = RequestMethod.POST)
  public ResponseEntity<EKeyInApiDto> saveAddNewContact(@RequestBody EKeyInApiDto param) throws Exception {
    return ResponseEntity.ok(eKeyInApiService.saveAddNewContact(param));
  }

  @ApiOperation(value = "selecteOrderProductHomecare", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/selecteOrderProductHomecare", method = RequestMethod.GET)
  public ResponseEntity<EKeyInApiDto> selecteOrderProductHomecare(EKeyInApiForm param) throws Exception {
    return ResponseEntity.ok(eKeyInApiService.selecteOrderProductHomecare(param));
  }

  @ApiOperation(value = "selectItmStkChangeInfo", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/selectItmStkChangeInfo", method = RequestMethod.GET)
  public ResponseEntity<EKeyInApiDto> selectItmStkChangeInfo(EKeyInApiForm param) throws Exception {
    return ResponseEntity.ok(eKeyInApiService.selectItmStkChangeInfo(param));
  }

  @ApiOperation(value = "selectPromoChange", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/selectPromoChange", method = RequestMethod.GET)
  public ResponseEntity<EKeyInApiDto> selectPromoChange(EKeyInApiForm param) throws Exception {
    return ResponseEntity.ok(eKeyInApiService.selectPromoChange(param));
  }

  @ApiOperation(value = "selectSrvType", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/selectSrvType", method = RequestMethod.GET)
  public ResponseEntity<EKeyInApiDto> selectSrvType(EKeyInApiForm param) throws Exception {
    return ResponseEntity.ok(eKeyInApiService.selectSrvType(param));
  }

  @ApiOperation(value = "selectAnotherAddress", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/selectAnotherAddress", method = RequestMethod.GET)
  public ResponseEntity<List<EKeyInApiDto>> selectAnotherAddress(EKeyInApiForm param) throws Exception {
    List<EgovMap> selectAnotherAddress = eKeyInApiService.selectAnotherAddress(param);
    if (LOGGER.isDebugEnabled()) {
      for (int i = 0; i < selectAnotherAddress.size(); i++) {
        LOGGER.debug("selectAnotherAddress    값 : {}", selectAnotherAddress.get(i));
      }
    }
    return ResponseEntity.ok(selectAnotherAddress.stream().map(r -> EKeyInApiDto.create(r)).collect(Collectors.toList()));
  }

  @ApiOperation(value = "saveAddNewAddress", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/saveAddNewAddress", method = RequestMethod.POST)
  public ResponseEntity<EKeyInApiDto> saveAddNewAddress(@RequestBody EKeyInApiDto param) throws Exception {
    return ResponseEntity.ok(eKeyInApiService.saveAddNewAddress(param));
  }

  @ApiOperation(value = "selectAnotherCard", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/selectAnotherCard", method = RequestMethod.GET)
  public ResponseEntity<List<EKeyInApiDto>> selectAnotherCard(EKeyInApiForm param) throws Exception {
    return ResponseEntity.ok(eKeyInApiService.selectAnotherCard(param));
  }

  @ApiOperation(value = "selectNewCardInfo", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/selectNewCardInfo", method = RequestMethod.GET)
  public ResponseEntity<EKeyInApiDto> selectNewCardInfo() throws Exception {
    return ResponseEntity.ok(eKeyInApiService.selectNewCardInfo());
  }

  @ApiOperation(value = "saveTokenLogging", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/saveTokenLogging", method = RequestMethod.POST)
  public ResponseEntity<EKeyInApiDto> saveTokenLogging(@RequestBody EKeyInApiDto param) throws Exception {
    return ResponseEntity.ok(eKeyInApiService.saveTokenLogging(param));
  }

  @ApiOperation(value = "saveTokenizationProcess", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/saveTokenizationProcess", method = RequestMethod.POST)
  public ResponseEntity<EKeyInApiDto> saveTokenizationProcess(@RequestBody EKeyInApiDto param) throws Exception {
    return ResponseEntity.ok(eKeyInApiService.saveTokenizationProcess(param));
  }

  @ApiOperation(value = "selectCheckRc", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/selectCheckRc", method = RequestMethod.GET)
  public ResponseEntity<EKeyInApiDto> selectCheckRc(EKeyInApiForm param) throws Exception {
    return ResponseEntity.ok(eKeyInApiService.selectCheckRc(param));
  }

  @ApiOperation(value = "selectExistSofNo", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/selectExistSofNo", method = RequestMethod.GET)
  public ResponseEntity<EKeyInApiDto> selectExistSofNo(EKeyInApiForm param) throws Exception {
    return ResponseEntity.ok(eKeyInApiService.selectExistSofNo(param));
  }

  @ApiOperation(value = "insertUploadFileSal0500", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
  @RequestMapping(value = "/insertUploadFileSal0500", method = RequestMethod.POST)
  public ResponseEntity<FileDto> insertUploadFileSal0500(@ApiIgnore MultipartHttpServletRequest request, @ModelAttribute EKeyInApiDto param) throws Exception {
    List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles(request, webUploadDir, param.getSubPath(), AppConstants.UPLOAD_MIN_FILE_SIZE, true);
    int fileGroupKey = eKeyInApiService.insertUploadFileSal0500(FileVO.createList(list), param);
    FileDto fileDto = FileDto.create(list, fileGroupKey);
    return ResponseEntity.ok(fileDto);
  }

  @ApiOperation(value = "updateUploadFileSal0500", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
  @RequestMapping(value = "/updateUploadFileSal0500", method = RequestMethod.POST)
  public ResponseEntity<FileDto> updateUploadFileSal0500(@ApiIgnore MultipartHttpServletRequest request, @ModelAttribute EKeyInApiDto param) throws Exception {
    List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles(request, webUploadDir, param.getSubPath(), AppConstants.UPLOAD_MIN_FILE_SIZE, true);

    int fileGroupKey = eKeyInApiService.updateUploadFileSal0500(FileVO.createList(list), param);
    FileDto fileDto = FileDto.create(list, fileGroupKey);
    return ResponseEntity.ok(fileDto);
  }

  @ApiOperation(value = "insertEkeyIn", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/insertEkeyIn", method = RequestMethod.POST)
  public ResponseEntity<EKeyInApiDto> insertEkeyIn(@RequestBody EKeyInApiDto param) throws Exception {
    return ResponseEntity.ok(eKeyInApiService.insertEkeyIn(param));
  }

  @ApiOperation(value = "updateEkeyIn", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/updateEkeyIn", method = RequestMethod.POST)
  public ResponseEntity<EKeyInApiDto> updateEkeyIn(@RequestBody EKeyInApiDto param) throws Exception {
    return ResponseEntity.ok(eKeyInApiService.updateEkeyIn(param));
  }

  @ApiOperation(value = "cancelEkeyIn", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/cancelEkeyIn", method = RequestMethod.POST)
  public ResponseEntity<EKeyInApiDto> cancelEkeyIn(@RequestBody EKeyInApiDto param) throws Exception {
    return ResponseEntity.ok(eKeyInApiService.cancelEkeyIn(param));
  }

  @RequestMapping(value = "/fileDownMobilEkeyin.do")
  public void fileDownMobilEkeyin(@RequestParam Map<String, Object> params, HttpServletRequest request, HttpServletResponse response) throws Exception {
    EKeyInApiDto selectAttachmentImgFile = eKeyInApiService.selectAttachmentImgFile(params);

    if (LOGGER.isDebugEnabled()) {
      LOGGER.debug("::::: webUploadDir : " + webUploadDir);
      LOGGER.debug("::::: getFileSubPath : " + selectAttachmentImgFile.getFileSubPath());
      LOGGER.debug("::::: getPhysiclFileName : " + selectAttachmentImgFile.getPhysiclFileName());
    }

    File uFile = new File(webUploadDir + selectAttachmentImgFile.getFileSubPath() + File.separator + selectAttachmentImgFile.getPhysiclFileName());
    long fSize = uFile.length();

    if (fSize > 0) {
      response.setContentType("application/x-msdownload");
      response.setHeader("Set-Cookie", "fileDownload=true; path=/"); /// resources/js/jquery.fileDownload.js
                                                                     /// callback
                                                                     /// 호출시 필수.
      setDisposition(selectAttachmentImgFile.getAtchFileName(), request, response);
      BufferedInputStream in = null;
      BufferedOutputStream out = null;

      try {
        in = new BufferedInputStream(new FileInputStream(uFile));
        out = new BufferedOutputStream(response.getOutputStream());

        FileCopyUtils.copy(in, out);
        out.flush();
      } catch (IOException ex) {
        EgovBasicLogger.ignore("IO Exception", ex);
      } finally {
        EgovResourceCloseHelper.close(in, out);
      }
    } else {
      throw new FileDownException(AppConstants.FAIL, "Could not get file name : " + selectAttachmentImgFile.getAtchFileName());
    }
  }

  private String getBrowser(HttpServletRequest request) {
    String header = request.getHeader("User-Agent");
    if (header.contains("MSIE")) {
      return "MSIE";
    } else if (header.contains("Trident")) { // IE11 문자열 깨짐 방지
      return "Trident";
    } else if (header.contains("Chrome")) {
      return "Chrome";
    } else if (header.contains("Opera")) {
      return "Opera";
    }
    return "Firefox";
  }

  private void setDisposition(String filename, HttpServletRequest request, HttpServletResponse response) throws Exception {
    String browser = getBrowser(request);

    String dispositionPrefix = "attachment; filename=";
    String encodedFilename = null;

    if (browser.equals("MSIE")) {
      encodedFilename = URLEncoder.encode(filename, "UTF-8").replaceAll("\\+", "%20");
    } else if (browser.equals("Trident")) { // IE11 문자열 깨짐 방지
      encodedFilename = URLEncoder.encode(filename, "UTF-8").replaceAll("\\+", "%20");
    } else if (browser.equals("Firefox")) {
      encodedFilename = "\"" + new String(filename.getBytes("UTF-8"), "8859_1") + "\"";
    } else if (browser.equals("Opera")) {
      encodedFilename = "\"" + new String(filename.getBytes("UTF-8"), "8859_1") + "\"";
    } else if (browser.equals("Chrome")) {
      StringBuilder sb = new StringBuilder();
      for (int i = 0; i < filename.length(); i++) {
        char c = filename.charAt(i);
        if (c > '~') {
          sb.append(URLEncoder.encode("" + c, "UTF-8"));
        } else {
          sb.append(c);
        }
      }
      encodedFilename = sb.toString();
    } else {
      throw new IOException("Not supported browser");
    }

    response.setHeader("Content-Disposition", dispositionPrefix + encodedFilename);

    if ("Opera".equals(browser)) {
      response.setContentType("application/octet-stream;charset=UTF-8");
    }
  }

  @ApiOperation(value = "selectCpntLst", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/selectCpntLst", method = RequestMethod.GET)
  public ResponseEntity<EKeyInApiDto> selectCpntLst(@ModelAttribute EKeyInApiForm param) throws Exception {
    return ResponseEntity.ok(eKeyInApiService.selectCpntLst(param));
  }

  @ApiOperation(value = "selectPromoByCpntId", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/selectPromoByCpntId", method = RequestMethod.GET)
  public ResponseEntity<EKeyInApiDto> selectPromoByCpntId(@ModelAttribute EKeyInApiForm param) throws Exception {
    LOGGER.debug("selectPromoByCpntId    값 : {}", param);
    return ResponseEntity.ok(eKeyInApiService.selectPromoByCpntId(param));
  }

  @ApiOperation(value = "getTokenId", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/getTokenId", method = RequestMethod.POST)
  public ResponseEntity<EKeyInApiDto> getTokenId(@RequestBody EKeyInApiDto param) throws Exception {
    EKeyInApiDto rtn = eKeyInApiService.getTokenId(param);
    return ResponseEntity.ok(rtn);
  }

  @ApiOperation(value = "saveTokenNumber", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/saveTokenNumber", method = RequestMethod.POST)
  public ResponseEntity<EKeyInApiDto> saveTokenNumber(@RequestBody EKeyInApiDto param) throws Exception {
    EKeyInApiDto rtn = eKeyInApiService.saveTokenNumber(param);
    return ResponseEntity.ok(rtn);
  }

  @ApiOperation(value = "checkIfIsAcInstallationProductCategoryCode", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/checkIfIsAcInstallationProductCategoryCode", method = RequestMethod.GET)
  public ResponseEntity<EKeyInApiDto> checkIfIsAcInstallationProductCategoryCode(@ModelAttribute EKeyInApiForm param) throws Exception {
    LOGGER.debug("selectPromoByCpntId    값 : {}", param);
    return ResponseEntity.ok(eKeyInApiService.checkIfIsAcInstallationProductCategoryCode(param));
  }

  @ApiOperation(value = "CHECK CARD TNA", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/checkTNA", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> checkTNA (@RequestParam String param) throws Exception {
    LOGGER.debug("checkTNA    값 : {}", param);
    return ResponseEntity.ok(eKeyInApiService.checkTNA(param));
  }

  @ApiOperation(value = "selectVoucherPlatformSelection", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/selectVoucherPlatformSelection", method = RequestMethod.GET)
  public ResponseEntity<List<EKeyInApiDto>> selectVoucherPlatformSelection(@ModelAttribute EKeyInApiForm param) throws Exception {
	    List<EgovMap> selectVoucherPlatformCodeList = eKeyInApiService.selectVoucherPlatformCodeList();
	    return ResponseEntity.ok(selectVoucherPlatformCodeList.stream().map(r -> EKeyInApiDto.create(r)).collect(Collectors.toList()));
  }

  @ApiOperation(value = "voucherApplyCheck", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/voucherApplyCheck", method = RequestMethod.GET)
  public ResponseEntity<EKeyInApiDto> voucherApplyCheck(@ModelAttribute EKeyInApiForm param) throws Exception {
	    return ResponseEntity.ok(eKeyInApiService.isVoucherValidToApply(param));
  }

  @ApiOperation(value = "getVoucherUsagePromotionId", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/getVoucherUsagePromotionId", method = RequestMethod.GET)
  public ResponseEntity<EKeyInApiDto> getVoucherUsagePromotionId(@ModelAttribute EKeyInApiForm param) throws Exception {
    return ResponseEntity.ok(eKeyInApiService.getVoucherUsagePromotionId(param));
  }
}
