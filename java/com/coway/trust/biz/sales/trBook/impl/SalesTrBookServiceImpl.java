package com.coway.trust.biz.sales.trBook.impl;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.coway.trust.biz.application.FileApplication;
import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.type.FileType;
import com.coway.trust.biz.sales.trBook.SalesTrBookService;
import com.coway.trust.cmmn.file.EgovFileUploadUtil;
import com.coway.trust.util.EgovFormBasedFileVo;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("salesTrBookService")
public class SalesTrBookServiceImpl  extends EgovAbstractServiceImpl implements SalesTrBookService{

	private static final Logger logger = LoggerFactory.getLogger(SalesTrBookServiceImpl.class);

	@Resource(name = "salesTrBookMapper")
	private SalesTrBookMapper salesTrBookMapper;

	@Autowired
	private MessageSourceAccessor messageSourceAccessor;

	@Autowired
	private FileApplication fileApplication;

/*	@Value("${com.file.upload.path}")
	private String uploadDir;*/

	@Value("${web.resource.upload.file}")
	private String uploadDir;


	@Override
	public List<EgovMap> selectTrBookList(Map<String, Object> params) {
		return salesTrBookMapper.selectTrBookList(params);
	}

	@Override
	public List<EgovMap> selectTrBookListByMem(Map<String, Object> params) {
		return salesTrBookMapper.selectTrBookListByMem(params);
	}

	@Override
	public EgovMap selectTrBookDetailInfo(Map<String, Object> params) {
		return salesTrBookMapper.selectTrBookDetailInfo(params);
	}

	@Override
	public List<EgovMap> selectTrBookDetailList(Map<String, Object> params) {

		salesTrBookMapper.selectTrBookDetailList(params);
		return (List<EgovMap>) params.get("p1");
	}

	@Override
	public int selectTrBookDup(Map<String, Object> params) {
		return salesTrBookMapper.selectTrBookDup(params);
	}

	@Override
	public String saveNewTrBook(Map<String, Object> params) {

		params.put("docNoId", 68);
		String docNo=salesTrBookMapper.getDocNo(params);

		params.put("docNo", docNo);

		salesTrBookMapper.insertTrBookM(params);

		params.put("trTypeId", 753);
		params.put("trLocCode", params.get("branch"));
		params.put("trRcordQyt", 1);
		salesTrBookMapper.insertTrRecord(params);

		for(int i = 0; i < Integer.parseInt(params.get("trBookPage").toString()) ; i++){

	        String StartNo = params.get("trNoFrom").toString().replace(params.get("prefix").toString(), "");

	        int StartNoInt = Integer.parseInt(StartNo) + i;
	        String format = "%0"+StartNo.length()+"d";

	        String trReciptNo = params.get("prefix").toString() + String.format(format, StartNoInt) ;

	        logger.debug("========================= trReciptNo =======>> " + trReciptNo);

			params.put("trReciptNo", trReciptNo);
			salesTrBookMapper.insertTrBookD(params);
		}

		return docNo;
	}

	@Override
	public List<EgovMap> selectBranch(Map<String, Object> params) {
		return 	salesTrBookMapper.selectBranch(params);
	}

	@Override
	public List<EgovMap> selectCourier(Map<String, Object> params) {
		return 	salesTrBookMapper.selectCourier(params);
	}

	@Override
	public List<EgovMap> selectMember(Map<String, Object> params) {
		return 	salesTrBookMapper.selectMember(params);
	}


	@Override
	public int selectTrBookDupBulk(Map<String, Object> params) {
		return salesTrBookMapper.selectTrBookDupBulk(params);
	}

	@Override
	public String saveNewTrBookBulk(Map<String, Object> params) {

		params.put("docNoId", 81);
		String docNo=salesTrBookMapper.getDocNo(params);

		params.put("reqNo", docNo);

		salesTrBookMapper.insertTrBookBulk(params);

		return docNo;
	}

	@Override
	public String saveAssign(Map<String, Object> params) {

		params.put("docNoId", 69);
		String docNo=salesTrBookMapper.getDocNo(params);

		params.put("docNo", docNo);

		params.put("trTrnsitTypeId", "751");
		params.put("trTrnsitStusId", "36");
		params.put("trTrnsitFrom", params.get("assingHolder"));
		params.put("trTrnsitTo", params.get("assignMemCode"));

		params.put("trBookId", params.get("assignHTrBookId"));
		params.put("trTrnsitResultStusId", 4);

		salesTrBookMapper.insertTrTransitM(params);

		salesTrBookMapper.insertTrTransitD(params);

		params.put("trTypeId", 754);
		params.put("trLocCode", params.get("assingHolder"));
		params.put("trRcordQyt", -1);
		salesTrBookMapper.insertTrRecord(params);

		params.put("trLocCode", params.get("assignMemCode"));
		params.put("trRcordQyt", 1);
		salesTrBookMapper.insertTrRecord(params);

		return docNo;
	}

	@Override
	public EgovMap selectTrBookInfo(Map<String, Object> params) {
		return salesTrBookMapper.selectTrBookInfo(params);
	}

	@Override
	public EgovMap selectMemberInfoByCode(Map<String, Object> params) {
		return salesTrBookMapper.selectMemberInfoByCode(params);
	}

	@Override
	public List<EgovMap> selectFeedBackCode() {
		return salesTrBookMapper.selectFeedBackCode();
	}

	@Override
	public int selectTrBookDetails(Map<String, Object> params) {
		return salesTrBookMapper.selectTrBookDetails(params);
	}

	@Override
	public void update_MSC0029D(Map<String, Object> params) {
		salesTrBookMapper.update_MSC0029D(params);
	}

	@Override
	public String saveReTrBook(Map<String, Object> params) {
		logger.debug("params =====================================>>  " + params);
		params.put("docNoId", 70);
		String docNo=salesTrBookMapper.getDocNo(params);

		params.put("docNo", docNo);


		params.put("trTrnsitTypeId", 752);
		//params.put("trTrnsitStusId", "36"); -- 화면에서....
		params.put("trTrnsitFrom", params.get("trReMemCode"));
		params.put("trTrnsitTo", params.get("branchCode"));

		params.put("trBookId", params.get("trReBookId"));
		params.put("trTrnsitResultStusId", 4);

		salesTrBookMapper.insertTrTransitM(params);

		salesTrBookMapper.insertTrTransitD(params);

		params.put("trTypeId", 755);
		params.put("trLocCode", params.get("trReMemCode"));
		params.put("trRcordQyt", -1);
		salesTrBookMapper.insertTrRecord(params);

		params.put("trLocCode", params.get("branchCode"));
		params.put("trRcordQyt", 1);
		salesTrBookMapper.insertTrRecord(params);

		salesTrBookMapper.updateTrBookM(params);

		List<EgovMap> list = salesTrBookMapper.selectTrBookDetailsList(params);

		if(list.size() > 0){
			for(EgovMap obj : list){

				Map<String, Object> param = new HashMap<String, Object>();

				param.put("trStusId", 36);
				param.put("userId", params.get("userId"));
				param.put("trBookItmId", obj.get("trBookItmId"));

				salesTrBookMapper.update_MSC0029D(param);
			}
		}

		return docNo;
	}

	@Override
	public EgovMap updateReportLost(Map<String, Object> params, MultipartHttpServletRequest request) throws Exception {

		int cnt = salesTrBookMapper.selectTrBookDetails(params);

		if(cnt > 0){
			salesTrBookMapper.update_MSC0029D(params);
		}

		EgovMap detailInfo = salesTrBookMapper.selectTrBookDetailInfo(params);

		EgovMap memberInfo = new EgovMap();

		if("Member".equals(detailInfo.get("trHolderType").toString())){
			memberInfo = salesTrBookMapper.selectMemberInfoByCode(detailInfo);
		}else{
			memberInfo = salesTrBookMapper.selectBranchInfoByCode(detailInfo);
		}

		params.put("docNoId", 48);
		String docNo=salesTrBookMapper.getDocNo(params);

		params.put("docNo", docNo);


		List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFilesNewName(request, uploadDir,
				File.separator + "DCF", 1024 * 1024 * 6, false, docNo+".zip");


		params.put("list", list);

		logger.debug("list SIZE=============" + list.size());

		if(list.size() > 0){

			params.put("hasAttach", 1);
			params.put("fileName", "~/WebShare" + list.get(0).getServerSubPath()+ File.separator + list.get(0).getFileName());

			fileApplication.businessAttach(FileType.WEB_DIRECT_RESOURCE, FileVO.createList(list), params);
		}


		salesTrBookMapper.insertRequestMaster(params);
		salesTrBookMapper.insertRequestDet(params);

		Map<String, Object> cf1 = new HashMap<>();

		cf1.put("dcfReqEntryId", params.get("dcfReqEntryId"));
		cf1.put("typeId", 9);
		cf1.put("refNo", detailInfo.get("trHolderType"));
		cf1.put("stusId", 1);
		cf1.put("userId", params.get("userId"));
		salesTrBookMapper.insertRequestComField(cf1);

		cf1.put("typeId", 3);
		cf1.put("refNo", memberInfo.get("memCode"));
		salesTrBookMapper.insertRequestComField(cf1);

		cf1.put("typeId", 7);
		cf1.put("refNo", params.get("trBookNo"));
		salesTrBookMapper.insertRequestComField(cf1);

		cf1.put("typeId", 8);
		cf1.put("refNo", "Piece");
		salesTrBookMapper.insertRequestComField(cf1);

		EgovMap saveView = new EgovMap();

		EgovMap reqMInfo = salesTrBookMapper.selectRequestMaster(params);

		if(reqMInfo != null){
			if("10".equals(reqMInfo.get("dcfReqStusId").toString())  || "34".equals(reqMInfo.get("dcfReqStusId").toString()) ){
				saveView.put("success", false);
				saveView.put("massage",  messageSourceAccessor.getMessage(SalesConstants.MSG_DCF_SETTLED));
			}else{

				params.put("dcfReqAppvRem",  messageSourceAccessor.getMessage(SalesConstants.MSG_DCF_OUTO_REM));

				//UPDATE REQUEST MASTER
				salesTrBookMapper.updateDCFRequestMs(params);

				reqMInfo = salesTrBookMapper.selectRequestMaster(params);

				if("36".equals(reqMInfo.get("dcfReqProStusId").toString()) && "34".equals(reqMInfo.get("dcfReqStusId").toString())){
					List<EgovMap> comFieldList = salesTrBookMapper.selectDCFCompulsoryFieldListByRequestID(reqMInfo);

					String bookNo = "";
					String holder = "";
					String lostType = "";
					for(EgovMap obj : comFieldList){

						if("7".equals(obj.get("dcfComFildTypeId").toString())){

							bookNo = obj.get("dcfReqComFildRefNo").toString();
						}
						if("3".equals(obj.get("dcfComFildTypeId").toString())){

							holder = obj.get("dcfReqComFildRefNo").toString();
						}
						if("8".equals(obj.get("dcfComFildTypeId").toString())){

							lostType = obj.get("dcfReqComFildRefNo").toString();
						}

					}

					params.put("bookNo", bookNo);
					params.put("return", "return");

					EgovMap trBookInfo = salesTrBookMapper.selectTrBookInfo(params);

					if(lostType.equals("Whole")){

					}else{

						List<EgovMap> changeItemList = salesTrBookMapper.selectDCFChangeItemListByRequestID(reqMInfo);

						for (EgovMap obj : changeItemList){

							params.put("trBookId", trBookInfo.get("trBookId"));
							params.put("trReceiptNo", obj.get("dcfReqDetFildChg"));
							params.put("dcfUpdate", "dcfUpdate");

							List<EgovMap> trBookDet = salesTrBookMapper.selectTrBookDetailsList(params);

							if(trBookDet != null){
								params.put("trStusId", 67);
								salesTrBookMapper.update_MSC0029D(params);
							}
						}
					}
				}
				// SAVE RESPOND LOG
				salesTrBookMapper.insertDCFResponseLogs(params);
			}


			saveView.put("success", true);
			saveView.put("massage", messageSourceAccessor.getMessage(SalesConstants.MSG_DCF_SUCC));
			saveView.put("reqMInfo", "reqMInfo");
			saveView.put("docNo", docNo);

		}else{

			saveView.put("success", false);
			saveView.put("massage",  messageSourceAccessor.getMessage(SalesConstants.MSG_DCF_UNABLE));
		}


		return saveView;
	}

	@Override
	public String saveTranSingle(Map<String, Object> params) {

		params.put("docNoId", 69);
		String docNo=salesTrBookMapper.getDocNo(params);

		params.put("docNo", docNo);

		params.put("trTrnsitTypeId", 750);
		params.put("trTrnsitStusId", 1);
		params.put("trTrnsitFrom", params.get("tranHolder"));
		params.put("trTrnsitTo", params.get("branch"));
		params.put("trCurierCode", params.get("courier"));
		params.put("trTrnsitResultStusId", 44);

		params.put("trBookId", params.get("tranTrBookId"));

		salesTrBookMapper.insertTrTransitM(params);

		salesTrBookMapper.insertTrTransitD(params);

		params.put("trTypeId", 754);
		params.put("trLocCode", params.get("tranHolder"));
		params.put("trRcordQyt", -1);
		salesTrBookMapper.insertTrRecord(params);

		params.put("trLocCode", params.get("courier"));
		params.put("trRcordQyt", 1);
		salesTrBookMapper.insertTrRecord(params);

		return null;
	}

	@Override
	public List<EgovMap> getOrganizationCodeList(Map<String, Object> params) {

		List<EgovMap> getOrganizationCodeList = null;

		if(Integer.parseInt(String.valueOf(params.get("memType"))) == 4 ){
			getOrganizationCodeList = salesTrBookMapper.getOrgCodeListByMemTypeStaff(params);
		}else{
			getOrganizationCodeList = salesTrBookMapper.getOrgCodeListByMemType(params);
		}

		return getOrganizationCodeList;
	}


	@Override
	public String saveTranBulk(Map<String, Object> params) {
		params.put("docNoId", 69);
		String docNo=salesTrBookMapper.getDocNo(params);

		params.put("docNo", docNo);

		params.put("trTrnsitTypeId", 750);
		params.put("trTrnsitStusId", 1);
		params.put("trTrnsitFrom", params.get("branchFrom"));
		params.put("trTrnsitTo", params.get("branchTo"));
		params.put("trCurierCode", params.get("courier"));
		params.put("trTrnsitResultStusId", 44);
		params.put("closDt", "1900-01-01");

		params.put("trBookId", params.get("tranTrBookId"));

		salesTrBookMapper.insertTrTransitM(params);

		List<Object> list = (List<Object>) params.get("gridData");


		logger.debug("list ========>> " + list);

		for (Object obj : list)
		{
			Map<String, Object> param = new HashMap();

			param.put("docNo", docNo);
			param.put("trTrnsitResultStusId", 44);
			param.put("userId", params.get("userId"));
			param.put("trTrnsitId", params.get("trTrnsitId"));
			param.put("trBookId",  ((Map<String, Object>) obj).get("trBookId"));

			salesTrBookMapper.insertTrTransitD(param);

			param.put("trTypeId", 754);
			param.put("trLocCode", params.get("branchFrom"));
			param.put("trRcordQyt", -1);
			salesTrBookMapper.insertTrRecord(param);

			param.put("trLocCode", params.get("courier"));
			param.put("trRcordQyt", 1);
			salesTrBookMapper.insertTrRecord(param);

		}

		return docNo;
	}

	@Override
	public List<EgovMap> selectTransitInfoList(Map<String, Object> params) {
		return salesTrBookMapper.selectTransitInfoList(params);
	}

	@Override
	public List<EgovMap> getCreateByList() throws Exception {
		return salesTrBookMapper.getCreateByList();
	}

	@Override
	public List<EgovMap> selelctRequestBahchList(Map<String, Object> params) {
		return salesTrBookMapper.selelctRequestBahchList(params);
	}

	@Override
	public EgovMap selelctRequestBahchInfo(Map<String, Object> params) {
		return salesTrBookMapper.selelctRequestBahchInfo(params);
	}

	@Override
	public void updateBkReqStus(Map<String, Object> params) {

		salesTrBookMapper.updateBkReqStus(params);


	}

	@Override
	public EgovMap selelctMemberInfoByCode(Map<String, Object> params) {
		return salesTrBookMapper.selelctMemberInfoByCode(params);
	}

	@Override
	public EgovMap selelctUnderDCFRequest(Map<String, Object> params) {
		return salesTrBookMapper.selelctUnderDCFRequest(params);
	}

	@Override
	public EgovMap selelctDcfMaster(Map<String, Object> params) {
		return salesTrBookMapper.selelctDcfMaster(params);
	}

	@Override
	public EgovMap saveReportLost(Map<String, Object> params) {

		String holderType = params.get("trHolderType").toString();
		logger.debug("params =====================================>>  " + params);

		params.put("docNoId", 48);
		String docNo=salesTrBookMapper.getDocNo(params);

		params.put("docNo", docNo);
		params.put("trNo", params.get("trBookNo"));

		salesTrBookMapper.insertRequestMaster(params);
		salesTrBookMapper.insertRequestDet(params);

		Map<String, Object> cf1 = new HashMap<>();

		cf1.put("dcfReqEntryId", params.get("dcfReqEntryId"));
		cf1.put("typeId", 9);
		cf1.put("refNo", params.get("trHolderType"));
		cf1.put("stusId", 1);
		cf1.put("userId", params.get("userId"));
		salesTrBookMapper.insertRequestComField(cf1);

		cf1.put("typeId", 3);
		logger.debug("params =====================================>>  " + holderType);
		if("Branch".equals(holderType))
		{
			cf1.put("refNo", params.get("trHolder"));
		}
		else
		{
			cf1.put("refNo", params.get("memCode"));

		}
		salesTrBookMapper.insertRequestComField(cf1);

		cf1.put("typeId", 7);
		cf1.put("refNo", params.get("trBookNo"));
		salesTrBookMapper.insertRequestComField(cf1);

		cf1.put("typeId", 8);
		cf1.put("refNo", "Whole");
		salesTrBookMapper.insertRequestComField(cf1);

		EgovMap saveView = new EgovMap();

		EgovMap reqMInfo = salesTrBookMapper.selectRequestMaster(params);

		if(reqMInfo != null){
			if("10".equals(reqMInfo.get("dcfReqStusId").toString())  || "34".equals(reqMInfo.get("dcfReqStusId").toString()) ){
				saveView.put("success", false);
				saveView.put("massage",  messageSourceAccessor.getMessage(SalesConstants.MSG_DCF_SETTLED));
			}else{

				params.put("dcfReqAppvRem",  messageSourceAccessor.getMessage(SalesConstants.MSG_DCF_OUTO_REM));

				//UPDATE REQUEST MASTER
				salesTrBookMapper.updateDCFRequestMs(params);

				reqMInfo = salesTrBookMapper.selectRequestMaster(params);

				if("36".equals(reqMInfo.get("dcfReqProStusId").toString()) && "34".equals(reqMInfo.get("dcfReqStusId").toString())){

					List<EgovMap> comFieldList = salesTrBookMapper.selectDCFCompulsoryFieldListByRequestID(reqMInfo);

					String bookNo = "";
					String holder = "";
					String lostType = "";


					for(EgovMap obj : comFieldList){
						logger.debug("11111111111111111111 " + obj.get("dcfComFildTypeId").toString());
						logger.debug("22222222222222222222 " + obj.get("dcfReqComFildRefNo").toString());


						if("7".equals(obj.get("dcfComFildTypeId").toString())){

							bookNo = obj.get("dcfReqComFildRefNo").toString();
						}
						if("3".equals(obj.get("dcfComFildTypeId").toString())){

							holder = obj.get("dcfReqComFildRefNo").toString();
						}
						if("8".equals(obj.get("dcfComFildTypeId").toString())){

							lostType = obj.get("dcfReqComFildRefNo").toString();
						}

					}


					params.put("bookNo", bookNo);
					params.put("return", "return");

					EgovMap trBookInfo = salesTrBookMapper.selectTrBookInfo(params);

					if(lostType.equals("Whole")){

						EgovMap trBookList = salesTrBookMapper.selectTrBookM(trBookInfo);

						if(trBookList != null){

							trBookInfo.put("trTrnsitStusId", 67);
							trBookInfo.put("userId", params.get("userId"));
							salesTrBookMapper.updateTrBookM(trBookInfo);

							List<EgovMap> trBookDet = salesTrBookMapper.selectTrBookDetailsList(trBookInfo);

							if(trBookDet != null){

								for(EgovMap detail : trBookDet){

									params.put("trStusId", 67);
									params.put("trBookItmId", detail.get("trBookItmId"));
									salesTrBookMapper.update_MSC0029D(params);
								}
							}

							params.put("trBookId", trBookInfo.get("trBookId"));
							params.put("trTypeId", 756);
							params.put("trLocCode", holder);
							params.put("trRcordQyt", -1);
							salesTrBookMapper.insertTrRecord(params);

						}
					}else{

						List<EgovMap> changeItemList = salesTrBookMapper.selectDCFChangeItemListByRequestID(reqMInfo);

						for (EgovMap obj : changeItemList){

							params.put("trBookId", trBookInfo.get("trBookId"));
							params.put("trReceiptNo", obj.get("dcfReqDetFildChg"));
							params.put("dcfUpdate", "dcfUpdate");

							List<EgovMap> trBookDet = salesTrBookMapper.selectTrBookDetailsList(params);

							if(trBookDet != null){
								params.put("trStusId", 67);
								salesTrBookMapper.update_MSC0029D(params);
							}
						}
					}
				}

				// SAVE RESPOND LOG
				salesTrBookMapper.insertDCFResponseLogs(params);
			}

			saveView.put("success", true);
			saveView.put("docNo", docNo);
			saveView.put("dcfReqEntryId", params.get("dcfReqEntryId"));

		}else{

			saveView.put("success", false);
			saveView.put("massage",  messageSourceAccessor.getMessage(SalesConstants.MSG_DCF_UNABLE));
		}

		return saveView;

	}

	@Override
	public EgovMap reportLostWholefileUpload(Map<String, Object> params, MultipartHttpServletRequest request) throws Exception {

		List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFilesNewName(request, uploadDir,
				File.separator + "DCF", 1024 * 1024 * 3, false, params.get("docNo").toString()+".zip");


		params.put("list", list);

		logger.debug("list SIZE=============" + list.size());

		if(list.size() > 0){

			params.put("hasAttach", 1);
			params.put("fileName", "~/WebShare" + list.get(0).getServerSubPath()+ File.separator + list.get(0).getFileName());

			fileApplication.businessAttach(FileType.WEB_DIRECT_RESOURCE, FileVO.createList(list), params);
		}

		salesTrBookMapper.updateFileName(params);

		return null;
	}

	@Override
	public void updateTrBookM(Map<String, Object> params) {
		salesTrBookMapper.updateTrBookM(params);
	}

	@Override
	public List<EgovMap> selelctBoxList(Map<String, Object> params) {
		return salesTrBookMapper.selelctBoxList(params);
	}

	@Override
	public void insertKeepIntoBox(Map<String, Object> params) {
		salesTrBookMapper.insertKeepIntoBoxD(params);

	}

	@Override
	public String insertKeepIntoNewBox(Map<String, Object> params) {

		params.put("docNoId", 71);
		String docNo=salesTrBookMapper.getDocNo(params);

		params.put("docNo", docNo);

		salesTrBookMapper.insertKeepIntoBox(params);

		salesTrBookMapper.insertKeepIntoBoxD(params);

		salesTrBookMapper.insertKeepIntoBoxRcord(params);

		return docNo;
	}


}
