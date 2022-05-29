package com.coway.trust.web.sales.pos;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.coway.trust.AppConstants;
import com.coway.trust.api.callcenter.common.FileDto;
import com.coway.trust.api.mobile.common.CommonConstants;
import com.coway.trust.biz.application.FileApplication;
import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.type.FileType;
import com.coway.trust.biz.sales.pos.PosEshopService;
import com.coway.trust.biz.sales.pos.PosStockService;
import com.coway.trust.cmmn.file.EgovFileUploadUtil;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.csv.CsvReadComponent;
import com.coway.trust.config.handler.SessionHandler;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.util.EgovFormBasedFileVo;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/sales/posstock")
public class PosEshopController {

  private static final Logger LOGGER = LoggerFactory.getLogger(PosEshopController.class);

  @Autowired
  private MessageSourceAccessor messageAccessor;

  @Autowired
  private SessionHandler sessionHandler;

  @Autowired
  private FileApplication fileApplication;

  @Resource(name = "posEshopService")
  private PosEshopService posEshopService;

  @Value("${com.file.upload.path}")
  private String uploadDir;

  @Value("${web.resource.upload.file}")
  private String uploadDirWeb;


  @RequestMapping(value = "/selectEshopList.do")
  public String selectEshopList(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {

    SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
    params.put("userId", sessionVO.getUserId());
    // TODO 유저 권한에 따라 리스트 검색 조건 변경 (추후)

    model.addAttribute("branchId", sessionVO.getUserBranchId());


    return "sales/pos/posEshopList";
  }

  @RequestMapping(value = "/eshopItemRegisterPop.do")
  public String eshopItemRegisterPop(@RequestParam Map<String, Object> params, ModelMap model) {

    return "sales/pos/eshopItemRegisterPop";

  }


  @RequestMapping(value = "/eshopItemEditPop.do")
  public String eshopItemEditPop(@RequestParam Map<String, Object> params, ModelMap model) {

    return "sales/pos/eshopItemEditPop";

  }

  @RequestMapping(value = "/selectItemPrice.do" ,method = RequestMethod.POST)
  public ResponseEntity<EgovMap> selectItemPrice(@RequestBody Map<String, Object> params, SessionVO sessionVO)
      throws Exception {


	EgovMap  rInfo = new EgovMap();

    List<EgovMap> itemlList = null;
    EgovMap  itemInfo = new EgovMap();


    itemInfo = posEshopService.selectItemPrice(params);

    rInfo.put("dataInfo",itemInfo);

    return ResponseEntity.ok(rInfo);
  }


  @RequestMapping(value = "/insertPosEshopItemList.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> insertPosEshopItemList(@RequestBody Map<String, Object> params) throws Exception {
    SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
    params.put("userId", sessionVO.getUserId());
    params.put("userDeptId", sessionVO.getUserDeptId());
    params.put("userName", sessionVO.getUserName());


    Map<String, Object> retunMap = null;

    LOGGER.debug(" params insertPosEshopItemList==dd=>"+params.toString());

    retunMap = posEshopService.insertPosEshopItemList(params);


    // Return MSG
    ReturnMessage message = new ReturnMessage();

    message.setCode(AppConstants.SUCCESS);
    message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
    message.setData(retunMap.get("scnNo"));

    return ResponseEntity.ok(message);

  }


  @RequestMapping(value = "/eShopItemUpload.do", method = RequestMethod.POST)
	public ResponseEntity<FileDto> eShopItemUpload(MultipartHttpServletRequest request,	@RequestParam Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception {

		List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles(request, uploadDirWeb,
				File.separator + "ESHOP" + File.separator + "ESHOP", 1024 * 1024 * 6);

		String param01 = (String) params.get("param01");

		params.put(CommonConstants.USER_ID, sessionVO.getUserId());

		//serivce 에서 파일정보를 가지고, DB 처리.
		int fileGroupKey = fileApplication.commonAttachByUserId(FileType.WEB, FileVO.createList(list), params);
		FileDto fileDto = FileDto.create(list, fileGroupKey);

		return ResponseEntity.ok(fileDto);
	}


	@RequestMapping(value = "/selectItemList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectAssignAgentList (@RequestParam Map<String, Object> params,
			HttpServletRequest request, ModelMap model) throws Exception{

		List<EgovMap> itemList = null;

		itemList = posEshopService.selectItemList(params);

		return ResponseEntity.ok(itemList);

	}

    @RequestMapping(value = "/removeEshopItemList.do", method = RequestMethod.POST)
    public ResponseEntity<ReturnMessage> removeEshopItemList(@RequestBody Map<String, Object> params,Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {
      SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
      params.put("userId", sessionVO.getUserId());
      params.put("userDeptId", sessionVO.getUserDeptId());
      params.put("userName", sessionVO.getUserName());

	  String searchDelItem = (String) params.get("delArr_addItem");
	  String[] searchItemvalue = searchDelItem.split("∈");

	  params.put("searchitemvalue", searchItemvalue);

      LOGGER.debug(" params removeEshopItemList==dd=>"+params.toString());

      Map<String, Object> retunMap = null;

      params.put("userId",  sessionVO.getUserId());

      retunMap = posEshopService.removeEshopItemList(params);

      // Return MSG
      ReturnMessage message = new ReturnMessage();

      message.setCode(AppConstants.SUCCESS);
      message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

      return ResponseEntity.ok(message);

    }

    @RequestMapping(value = "/updatePosEshopItemList.do", method = RequestMethod.POST)
    public ResponseEntity<ReturnMessage> updatePosEshopItemList(@RequestBody Map<String, Object> params) throws Exception {
      SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
      params.put("userId", sessionVO.getUserId());
      params.put("userDeptId", sessionVO.getUserDeptId());
      params.put("userName", sessionVO.getUserName());

      Map<String, Object> retunMap = null;

      LOGGER.debug(" params insertPosEshopItemList==dd=>"+params.toString());

      retunMap = posEshopService.updatePosEshopItemList(params);


      // Return MSG
      ReturnMessage message = new ReturnMessage();

      message.setCode(AppConstants.SUCCESS);
      message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
      message.setData(retunMap.get("scnNo"));

      return ResponseEntity.ok(message);

    }



}
