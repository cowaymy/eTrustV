package com.coway.trust.api.mobile.payment.autodebit;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.support.MessageSourceAccessor;
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
import com.coway.trust.api.mobile.payment.payment.PaymentForm;
import com.coway.trust.api.mobile.sales.eKeyInApi.EKeyInApiDto;
import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.payment.autodebit.service.AutoDebitService;
import com.coway.trust.biz.payment.common.service.CommonPaymentService;
import com.coway.trust.cmmn.file.EgovFileUploadUtil;
import com.coway.trust.util.EgovFormBasedFileVo;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import springfox.documentation.annotations.ApiIgnore;


/**
 * @ClassName : AutoDebitApiController.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 9. 30.   KR-HAN        First creation
 * </pre>
 */

@Api(value = "autodebit api", description = "autodebit api")
@RestController(value = "autoDebitApiController")
@RequestMapping(AppConstants.MOBILE_API_BASE_URI + "/autodebit")
public class AutoDebitApiController {

	private static final Logger LOGGER = LoggerFactory.getLogger(AutoDebitApiController.class);

	@Resource(name = "autoDebitService")
	private AutoDebitService autoDebitService;

    @Value("${web.resource.upload.file}")
    private String webUploadDir;

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@ApiOperation(value = "Order No List", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/orderNumberSearch", method = RequestMethod.GET)
	public ResponseEntity<List<AutoDebitApiDto>> orderNumberSearch(@ModelAttribute AutoDebitApiForm autoDebitApiForm) throws Exception {
       Map<String, Object> params = autoDebitApiForm.createMap(autoDebitApiForm);
       List<EgovMap> selectOrderList = null;
       selectOrderList = autoDebitService.orderNumberSearchMobile(params);

       List<AutoDebitApiDto> orderListResult = selectOrderList.stream().map(r -> AutoDebitApiDto.create(r)).collect(Collectors.toList());

       return ResponseEntity.ok(orderListResult);
	}

	@ApiOperation(value = "Auto Debit History List", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/autoDebitHistoryList", method = RequestMethod.GET)
	public ResponseEntity<List<AutoDebitApiDto>> autoDebitHistoryList(@ModelAttribute AutoDebitApiForm autoDebitApiForm) throws Exception {
       Map<String, Object> params = autoDebitApiForm.createMap(autoDebitApiForm);
       List<EgovMap> selectHistoryList = null;
       selectHistoryList = autoDebitService.autoDebitHistoryMobileList(params);

       List<AutoDebitApiDto> historyListResult = selectHistoryList.stream().map(r -> AutoDebitApiDto.create(r)).collect(Collectors.toList());

       return ResponseEntity.ok(historyListResult);
	}

	@ApiOperation(value = "Auto Debit Submission Save", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/autoDebitSubmissionSave", method = RequestMethod.POST)
	public void autoDebitSubmissionSave(@RequestBody AutoDebitApiForm autoDebitApiForm) throws Exception {
        Map<String, Object> params = AutoDebitApiForm.createMap(autoDebitApiForm);
    	autoDebitService.autoDebitMobileSubmissionSave(params);
	}

	 @ApiOperation(value = "Auto Debit Submission Attachment Save", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
	  @RequestMapping(value = "/autoDebitSubmissionAttachmentSave", method = RequestMethod.POST)
	  public ResponseEntity<FileDto> autoDebitSubmissionAttachmentSave(@ApiIgnore MultipartHttpServletRequest request,
	      @ModelAttribute AutoDebitApiForm param) throws Exception {
	    List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles(request, webUploadDir, param.getSubPath(),
	        AppConstants.UPLOAD_MIN_FILE_SIZE, true);
	    Map<String, Object> params = AutoDebitApiForm.createMap(param);
	    int fileGroupKey = autoDebitService.insertAttachmentMobileUpload(FileVO.createList(list), params);
	    FileDto fileDto = FileDto.create(list, fileGroupKey);
	    return ResponseEntity.ok(fileDto);
	  }
}
