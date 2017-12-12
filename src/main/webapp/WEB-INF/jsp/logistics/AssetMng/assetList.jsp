<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>

<style type="text/css">

/* 커스텀 칼럼 스타일 정의 */
.aui-grid-user-custom-left {
    text-align:left;
}

/* 커스컴 disable 스타일*/
.mycustom-disable-color {
    color : #cccccc;
}

/* 그리드 오버 시 행 선택자 만들기 */
.aui-grid-body-panel table tr:hover {
    background:#D9E5FF;
    color:#000;
}
.aui-grid-main-panel .aui-grid-body-panel table tr td:hover {
    background:#D9E5FF;
    color:#000;
}


</style>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery.blockUI.min.js"></script>
<script type="text/javaScript" language="javascript">


    // AUIGrid 생성 후 반환 ID
    var myGridID;
    var detailGrid;
    var AddDetailGrid;
    var addItemGrid;
    var multyitemGrid;
    var assetMoveTrnsGrid;
    var assetMoveTrnsBulkGrid;
    var srvMembershipList = new Array();
    var upBramdList = new Array();
    var upitemGrid;
    var copyDetails;
    
    var comboData = [{"codeId": "1","codeName": "Active"},{"codeId": "7","codeName": "Obsolete"},{"codeId": "67","codeName": "Lost"},{"codeId": "8","codeName": "Inactive"}];
   // var categorycomboData = [{"codeId": "1199","codeName": "IT Equipment"}];
    //var instockgradecomboData = [{"codeId": "A","codeName": "A"}];
    
    var url;
    // AUIGrid 칼럼 설정                                                                            visible : false
    var columnLayout = [{dataField:"assetid"      ,headerText:"Asset ID"           ,width:"5%"  ,height:30 , visible:true},
                        {dataField:"name2"      ,headerText:"Status"           ,width:"8%" ,height:30 , visible:true},
                        {dataField:"codename2"    ,headerText:"Type"    ,width:"12%" ,height:30 , visible:true},
                        {dataField:"name"   ,headerText:"Brand"       ,width:120 ,height:30 , visible:true},
                        {dataField:"name1"   ,headerText:"Model Name"       ,width:140 ,height:30 , visible:true},
                        {dataField:"codename1"   ,headerText:"Color"       ,width:90 ,height:30 , visible:true},
                        {dataField:"branch"    ,headerText:"Branch"        ,width:120 ,height:30 , visible:true},
                        {dataField:"department"    ,headerText:"Department"        ,width:140 ,height:30 , visible:true},
                        {dataField:"purchsdt"    ,headerText:"Purchase Date"        ,width:120 ,height:30 , visible:true},
                        {dataField:"username2"    ,headerText:"Current User"        ,width:120  ,height:30 , visible:true},
                        {dataField:"refno"    ,headerText:"Ref No"        ,width:120  ,height:30 , visible:true},
                        {dataField:"dealername"    ,headerText:"Dealer"        ,width:120  ,height:30 , visible:true},
                        {dataField:"invcno"    ,headerText:"Inv No"        ,width:120 ,height:30 , visible:true},                     
                        {dataField:"brandid"  ,headerText:"brandId"     ,width:100 ,height:30 , visible:false},
                        {dataField:"ctgryid"    ,headerText:"ctgryId"        ,width:100 ,height:30 , visible:false},                      
                        {dataField:"codename"    ,headerText:"codeName"        ,width:100 ,height:30 , visible:false},                      
                        {dataField:"colorId"  ,headerText:"codeName1"      ,width:100 ,height:30 , visible:false},                      
                        {dataField:"crtdt"   ,headerText:"crtDt"       ,width:100 ,height:30 , visible:false},                       
                        {dataField:"crtuserid"      ,headerText:"crtUserId"          ,width:100 ,height:30 , visible:false},
                        {dataField:"currbrnchid"      ,headerText:"currBrnchId"          ,width:100 ,height:30 , visible:false},                        
                        {dataField:"currdeptid"     ,headerText:"currDeptId"         ,width:100 ,height:30 , visible:false},                    
                        {dataField:"curruserid"     ,headerText:"currUserId"         ,width:100 ,height:30 , visible:false},                      
                        {dataField:"username"       ,headerText:"userName2"           ,width:100 ,height:30 , visible:false},                       
                        {dataField:"imeino"       ,headerText:"imeiNo"           ,width:100 ,height:30 , visible:false},                      
                        {dataField:"macaddr"  ,headerText:"macAddr"      ,width:100 ,height:30 , visible:false},                      
                        {dataField:"purchsamt"   ,headerText:"purchsAmt"       ,width:100 ,height:30 , visible:false},                      
                        {dataField:"assetrem"   ,headerText:"assetRem"         ,width:"15%" ,height:30 , visible:false},                       
                        {dataField:"serialno"      ,headerText:"serialNo"          ,width:100 ,height:30 , visible:false},                        
                         {dataField:"stusid"      ,headerText:"stusId"          ,width:100 ,height:30 , visible:false},                 
                        {dataField:"typeid"     ,headerText:"typeId"           ,width:"15%" ,height:30 , visible:false},                   
                        {dataField:"upddt"     ,headerText:"updDt"         ,width:"10%" ,height:30 , visible:false},                      
                        {dataField:"upduserid"    ,headerText:"upd_user_Id"        ,width:100 ,height:30 , visible:false},
                        {dataField:"username1"  ,headerText:"userName1"      ,width:100 ,height:30 , visible:false},                       
                        {dataField:"wrantyno"  ,headerText:"wrantyNo"      ,width:100 ,height:30 , visible:false},                      
                        {dataField:"dealerid"  ,headerText:"dealerId"      ,width:100 ,height:30 , visible:false},
                       ];
    
    
    var detailLayout = [ {dataField:"codeName"      ,headerText:"Type"          ,width:"12%" ,height:30 , visible:true}, 
                         {dataField:"name"      ,headerText:"Brand"           ,width:"15%" ,height:30 , visible:true}, 
                        {dataField:"name1"    ,headerText:"Model Name"    ,width:"40%" ,height:30 , visible:true},
                        {dataField:"assetDRem"        ,headerText:"Remark1"        ,width:"15%" ,height:30 , visible:true},
                        {dataField:"name3"   ,headerText:"Name"         ,width:"15%" ,height:30 , visible:true},
                        {dataField:"valu"   ,headerText:"Value"       ,width:"15%" ,height:30 , visible:true},
                        {dataField:"assetDItmRem"   ,headerText:"Remark2"       ,width:120 ,height:30 , visible:true},
                       ];
    var insDetailLayout = [ {dataField:"codeName"      ,headerText:"Type"          ,width:"12%" ,height:30 , visible:true}, 
                         {dataField:"name"      ,headerText:"Brand"           ,width:"15%" ,height:30 , visible:true}, 
                        {dataField:"name1"    ,headerText:"Model Name"    ,width:"40%" ,height:30 , visible:true},
                        {dataField:"assetDRem"        ,headerText:"Remark1"        ,width:"15%" ,height:30 , visible:true},
                        {dataField:"typeid"      ,headerText:"Type"          ,width:"12%" ,height:30 , visible:false}, 
                        {dataField:"brandid"      ,headerText:"Type"          ,width:"12%" ,height:30 , visible:false}, 
                        {
                            dataField : "",
                            headerText : "",
                            renderer : {
                                type : "ButtonRenderer",
                                labelText : "Remove",
                                onclick : function(rowIndex, columnIndex, value, item) {
                                    gridNm = AddDetailGrid;
                                   removeRow(rowIndex, gridNm);
                                }
                            }
                          }];
    
/*     var updateLayout = [ {dataField:"codeName"      ,headerText:"Type"          ,width:"12%" ,height:30 , visible:true}, 
                         {dataField:"name"      ,headerText:"Brand"           ,width:"15%" ,height:30 , visible:true}, 
                        {dataField:"name1"    ,headerText:"Model Name"    ,width:"40%" ,height:30 , visible:true},
                        {dataField:"assetDRem"        ,headerText:"Remark1"        ,width:"15%" ,height:30 , visible:true},
                        {dataField:"name3"   ,headerText:"Name"         ,width:"15%" ,height:30 , visible:true},
                        {dataField:"valu"   ,headerText:"Value"       ,width:"15%" ,height:30 , visible:true},
                        {dataField:"assetDItmRem"   ,headerText:"Remark2"       ,width:120 ,height:30 , visible:true},
                        {dataField:"typeid"      ,headerText:"Type"          ,width:"12%" ,height:30 , visible:false}, 
                        {dataField:"brandid"      ,headerText:"Type"          ,width:"12%" ,height:30 , visible:false},
                        {dataField:"assetDId"      ,headerText:"AssetDid"          ,width:"12%" ,height:30 , visible:true},
                        {dataField:"assetDItmId"      ,headerText:"ASSET_D_ITM_ID"          ,width:"12%" ,height:30 , visible:true},
                        {
                            dataField : "",
                            headerText : "",
                            renderer : {
                                type : "ButtonRenderer",
                                labelText : "Remove",
                                onclick : function(rowIndex, columnIndex, value, item) {
                                   gridNm = upitemGrid;
                                   removeItem(rowIndex, gridNm);
                                }
                            } 
                        }]; */
        var updateLayout = [ {dataField:"codeName"      ,headerText:"Type"          ,width:120 ,height:30 , style :"aui-grid-user-custom-left", 
                                         labelFunction : function(rowIndex, columnIndex, value, headerText, item) {
                                            var retStr = "";
                                            for (var i = 0, len = srvMembershipList.length; i < len; i++) {
                                                if (srvMembershipList[i]["codeId"] == value) {
                                                    retStr = srvMembershipList[i]["codeName"];
                                                    break;
                                                }
                                            }
                                            return retStr == "" ? value : retStr;                                         
                                        },  
                                      editRenderer : {
                                          type : "ComboBoxRenderer",
                                          showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
                                          listFunction : function(rowIndex, columnIndex, item, dataField) {
//                                         	  item.codeId =srvMembershipList[i]["codeId"]
//                                         	  alert(item.codeId);                                   	  
//                                         	  for (var i = 0, len = srvMembershipList.length; i < len; i++) {
//                                         		  srvMembershipList[i]["codeId"] = value;
//                                         		  srvMembershipList[i]["codeName"];
//                                         	  }
                                              return srvMembershipList ;
                                          },
                                          keyField : "codeId",
                                          valueField : "codeName"                                            
                                                      }
                                            },   
                        {dataField:"name"      ,headerText:"Brand"           ,width:120 ,height:30 , style :"aui-grid-user-custom-left", 
                                                 labelFunction : function(rowIndex, columnIndex, value, headerText, item) {
                                                     var retStr = "";
                                                     for (var i = 0, len = upBramdList.length; i < len; i++) {
                                                         if (upBramdList[i]["codeId"] == value) {
                                                             retStr = upBramdList[i]["codeName"];
                                                             break;
                                                         }
                                                     }
                                                     return retStr == "" ? value : retStr;
                                                 },  
                                               editRenderer : {
                                                   type : "ComboBoxRenderer",
                                                   showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
                                                   listFunction : function(rowIndex, columnIndex, item, dataField) {
                                                       return upBramdList ;
                                                   },
                                                   keyField : "codeId",
                                                   valueField : "codeName"
                                                               }
                                                 }, 
                       {dataField:"name1"    ,headerText:"Model Name"    ,width:120 ,height:30 , visible:true},
                       {dataField:"assetDRem"        ,headerText:"Remark1"        ,width:120 ,height:30 , visible:true},
                       {dataField:"name3"   ,headerText:"Name"         ,width:120 ,height:30 , visible:true},
                       {dataField:"valu"   ,headerText:"Value"       ,width:120 ,height:30 , visible:true},
                       {dataField:"assetDItmRem"   ,headerText:"Remark2"       ,width:120 ,height:30 , visible:true},
                       {dataField:"typeid"      ,headerText:"Type"          ,width:120 ,height:30 , visible:false}, 
                       {dataField:"brandid"      ,headerText:"Type"          ,width:120 ,height:30 , visible:false},
                       {dataField:"assetDId"      ,headerText:"AssetDid"          ,width:120 ,height:30 , visible:true},
                       {dataField:"assetDItmId"      ,headerText:"ASSET_D_ITM_ID"          ,width:120 ,height:30 , visible:true},
                       {
                           dataField : "",
                           headerText : "",
                           renderer : {
                               type : "ButtonRenderer",
                               labelText : "Remove",
                               onclick : function(rowIndex, columnIndex, value, item) {
                                  gridNm = upitemGrid;
                                  UpremoveRow(rowIndex, gridNm);
                               }
                           } 
                       }]; 
                                            
                        
    var additemLayout = [ {dataField:"codeName"      ,headerText:"Type"          ,width:"12%" ,height:30 , visible:true}, 
                         {dataField:"name"      ,headerText:"Brand"           ,width:"15%" ,height:30 , visible:true}, 
                        {dataField:"name1"    ,headerText:"Model Name"    ,width:"40%" ,height:30 , visible:true},
                        {dataField:"assetDRem"        ,headerText:"Remark1"        ,width:"15%" ,height:30 , visible:true},
                        {dataField:"name3"   ,headerText:"Name"         ,width:"15%" ,height:30 , visible:true},
                        {dataField:"valu"   ,headerText:"Value"       ,width:"15%" ,height:30 , visible:true},
                        {dataField:"assetDItmRem"   ,headerText:"Remark2"       ,width:120 ,height:30 , visible:true},
                        {dataField:"typeid"      ,headerText:"Type"          ,width:"12%" ,height:30 , visible:false}, 
                        {dataField:"brandid"      ,headerText:"BrandID"          ,width:"12%" ,height:30 , visible:false},
                        {dataField:"assetid"      ,headerText:"Asset ID"           ,width:"5%"  ,height:30 , visible:false},
                        {
                            dataField : "",
                            headerText : "",
                            renderer : {
                                type : "ButtonRenderer",
                                labelText : "Remove",
                                onclick : function(rowIndex, columnIndex, value, item) {
                                   gridNm = addItemGridss;
                                   removeRow(rowIndex, gridNm);
                                }
                            } 
                        }];
    var asstMoveTrnsLayout = [ {dataField:"cardId" ,headerText:"cardId",width:120 ,height:30, visible:false},
                               {dataField:"crtDt" ,headerText:"Date",width:"15%" ,height:30},
                               {dataField:"userName" ,headerText:"Creator",width:"15%" ,height:30},
                               {dataField:"codeName" ,headerText:"Type",width:"20%" ,height:30},
                               {dataField:"brnchId" ,headerText:"Branch",width:120 ,height:30, visible:false},
                               {dataField:"deptId" ,headerText:"Department",width:120 ,height:30, visible:false},
                               {dataField:"assetId" ,headerText:"assetId",width:120 ,height:30, visible:false},
                               {dataField:"c1" ,headerText:"Branch",width:"15%" ,height:30},
                               {dataField:"cardDocNo" ,headerText:"cardDocNo",width:120 ,height:30, visible:false},
                               {dataField:"cardTypeId" ,headerText:"cardTypeId",width:120 ,height:30, visible:false},
                               {dataField:"crtUserId" ,headerText:"crtUserId",width:120 ,height:30, visible:false},
                               {dataField:"c2" ,headerText:"Department",width:"20%" ,height:30},
                               {dataField:"qty" ,headerText:"Qty",width:"15%" ,height:30}
];
    
    var bulkLayout = [{dataField:"assetid"      ,headerText:"Asset ID"           ,width:80 ,height:30 , visible:true},
                        {dataField:"name2"      ,headerText:"Status"           ,width:80 ,height:30 , visible:true},
                        {dataField:"codename2"    ,headerText:"Type"    ,width:140 ,height:30 , visible:true},
                        {dataField:"name"   ,headerText:"Brand"       ,width:120 ,height:30 , visible:true},
                        {dataField:"name1"   ,headerText:"Model Name"       ,width:140 ,height:30 , visible:true},
                        {dataField:"codename1"   ,headerText:"Color"       ,width:90 ,height:30 , visible:true},
                        {dataField:"branch"    ,headerText:"Branch"        ,width:120 ,height:30 , visible:true},
                        {dataField:"department"    ,headerText:"Department"        ,width:140 ,height:30 , visible:true},
                        {dataField:"purchsdt"    ,headerText:"Purchase Date"        ,width:120 ,height:30 , visible:true},
                        {dataField:"username2"    ,headerText:"Current User"        ,width:120  ,height:30 , visible:true},
                        {dataField:"refno"    ,headerText:"Ref No"        ,width:150  ,height:30 , visible:true},
                        {dataField:"dealername"    ,headerText:"Dealer"        ,width:120  ,height:30 , visible:false},
                        {dataField:"invcno"    ,headerText:"Inv No"        ,width:120 ,height:30 , visible:false},                     
                        {dataField:"brandid"  ,headerText:"brandId"     ,width:100 ,height:30 , visible:false},
                        {dataField:"ctgryid"    ,headerText:"ctgryId"        ,width:100 ,height:30 , visible:false},                      
                        {dataField:"codename"    ,headerText:"codeName"        ,width:100 ,height:30 , visible:false},                      
                        {dataField:"colorId"  ,headerText:"codeName1"      ,width:100 ,height:30 , visible:false},                      
                        {dataField:"crtdt"   ,headerText:"crtDt"       ,width:100 ,height:30 , visible:false},                       
                        {dataField:"crtuserid"      ,headerText:"crtUserId"          ,width:100 ,height:30 , visible:false},
                        {dataField:"currbrnchid"      ,headerText:"currBrnchId"          ,width:100 ,height:30 , visible:false},                        
                        {dataField:"currdeptid"     ,headerText:"currDeptId"         ,width:100 ,height:30 , visible:false},                    
                        {dataField:"curruserid"     ,headerText:"currUserId"         ,width:100 ,height:30 , visible:false},                      
                        {dataField:"username"       ,headerText:"userName2"           ,width:100 ,height:30 , visible:false},                       
                        {dataField:"imeino"       ,headerText:"imeiNo"           ,width:100 ,height:30 , visible:false},                      
                        {dataField:"macaddr"  ,headerText:"macAddr"      ,width:100 ,height:30 , visible:false},                      
                        {dataField:"purchsamt"   ,headerText:"purchsAmt"       ,width:100 ,height:30 , visible:false},                      
                        {dataField:"assetrem"   ,headerText:"assetRem"         ,width:120 ,height:30 , visible:false},                       
                        {dataField:"serialno"      ,headerText:"serialNo"          ,width:100 ,height:30 , visible:false},                        
                        {dataField:"stusid"      ,headerText:"stusId"          ,width:100 ,height:30 , visible:false},              
                        {dataField:"typeid"     ,headerText:"typeId"           ,width:120,height:30 , visible:false},                   
                        {dataField:"upddt"     ,headerText:"updDt"         ,width:120 ,height:30 , visible:false},                      
                        {dataField:"upduserid"    ,headerText:"upd_user_Id"        ,width:100 ,height:30 , visible:false},
                        {dataField:"username1"  ,headerText:"userName1"      ,width:100 ,height:30 , visible:false},                       
                        {dataField:"wrantyno"  ,headerText:"wrantyNo"      ,width:100 ,height:30 , visible:false},                      
                        {dataField:"dealerid"  ,headerText:"dealerId"      ,width:100 ,height:30 , visible:false},
                       ];   
    
 /* 그리드 속성 설정
  usePaging : true, pageRowCount : 30,  fixedColumnCount : 1,// 페이지 설정
  editable : false,// 편집 가능 여부 (기본값 : false) 
  enterKeyColumnBase : true,// 엔터키가 다음 행이 아닌 다음 칼럼으로 이동할지 여부 (기본값 : false)
  selectionMode : "multipleCells",// 셀 선택모드 (기본값: singleCell)                
  useContextMenu : true,// 컨텍스트 메뉴 사용 여부 (기본값 : false)                
  enableFilter : true,// 필터 사용 여부 (기본값 : false)            
  useGroupingPanel : true,// 그룹핑 패널 사용
  showStateColumn : true,// 상태 칼럼 사용
  displayTreeOpen : true,// 그룹핑 또는 트리로 만들었을 때 펼쳐지게 할지 여부 (기본값 : false)
  noDataMessage : "출력할 데이터가 없습니다.",
  groupingMessage : "여기에 칼럼을 드래그하면 그룹핑이 됩니다.",
  rowIdField : "stkid",
  enableSorting : true,
  showRowCheckColumn : true,
  */
    var gridoptions = {showStateColumn : false , editable : false, usePaging : false, useGroupingPanel : false ,exportURL : "/common/exportGrid.do" };
    
    var subgridpros = {
            // 페이지 설정
            usePaging : true,                
            pageRowCount : 10,                
            editable : true,                
            noDataMessage : "<spring:message code='sys.info.grid.noDataMessage'/>",
            enableSorting : true,
            softRemoveRowMode:false
            };
    

    $(document).ready(function(){
    	/* 2017-12-06 log */
        // masterGrid 그리드를 생성합니다.
        myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,"", gridoptions);
        
        doDefCombo(comboData, '' ,'searchstatus', 'M', 'f_multiCombo');
        $("#searchstatus option:eq(0)").prop("selected", true);
          
       doGetCombo('/logistics/assetmng/selectTypeList.do', '1199', 'all','searchtype', 'M' , 'f_TypeMultiCombo'); //Type 리스트 조회
             
        doGetCombo('/logistics/assetmng/selectDealerList.do', '1', '','searchdealer', 'S' , '');//dealer 
        doGetCombo('/common/selectCodeList.do', '112', '','searchcolor', 'S' , ''); //Color 리스트 조회
        doGetCombo('/common/selectCodeList.do', '112', '','mastercolor', 'S' , ''); //Color 리스트 조회
        doGetCombo('/common/selectCodeList.do', '111', '','mastertype', 'S' , ''); //Type 리스트 조회
        doGetCombo('/common/selectCodeList.do', '108', '','searchcategory', 'S' , ''); //category 리스트 조회
        doGetCombo('/common/selectCodeList.do', '108', '','mastercategory', 'S' , ''); //category 리스트 조회  
        doGetCombo('/logistics/assetmng/selectDealerList.do', '1', '','masterdealer', 'S' , '');//dealer 리스트 조회
        doGetCombo('/logistics/assetmng/selectBrandList.do', '', '','masterbrand', 'S' , '');//brand 리스트 조회
        doGetComboSepa('/common/selectBranchCodeList.do', '3' , ' - ' , '','searchbranchid', 'S' , ''); //청구처 리스트 조회
        doDefCombo('', '' ,'searchdepartment', 'M', 'f_deptmultiCombo');
                
        
        AUIGrid.bind(myGridID, "cellClick", function( event )  
        {
            
            
        });
        
        // 셀 더블클릭 이벤트 바인딩
        AUIGrid.bind(myGridID, "cellDoubleClick", function(event) 
        {
            
            var selectedItem = AUIGrid.getSelectedIndex(myGridID);
            if (selectedItem[0] > -1){
                div="V";              
                $("#detailHead").text("AssetMng Information Details");
                fn_setVisiable(div); 
                fn_assetDetail(selectedItem[0]);
                 //$("#Master_info").trigger("click");
                 $("#masterWindow").show();
                 $("#Details_info").show();
                 $("#Insert_info").hide();
                 $("#Update_info").hide();
                 $("#CopyAssetInfo").hide();
                 $("#trnasInfo").hide();
                 $("#transH3_01").hide();
                 $("#cancelPopbtn").hide();
                 $("#trigger").trigger("click");
            }else{
            Common.alert('Choice Data please..');
            }
         //  $("#masterWindow").show();
        });
       
        /* 팝업 드래그 start */
        $("#popup_wrap, .popup_wrap").draggable({handle: '.pop_header'});
        /* 팝업 드래그 end */
        });
                
        $(function(){
            //all select 값 주기
            $('#searchcategory').change(function() {
                $('#searchtype').multipleSelect("enable");
                $('#searchtype').multipleSelect("checkAll");
                
            });
         
            
            $("#search").click(function(){
                getAssetListAjax();    
            });
            $("#masterClose").click(function(){
                AUIGrid.destroy(upitemGrid);
                $("#trigger").trigger("click");
                copyDetails="A";
            });
            
            $("#clear").click(function(){
                $("#searchassetid").val('');
                $("#searchbrand").val('');
                $("#searchmodelname").val('');
                $("#searchpurchasedate1").val('');
                $("#searchpurchasedate2").val('');
                $("#searchrefno").val('');
                $("#searchinvoiceno").val('');
                $("#searchserialno").val('');
                $("#searchwarrantyno").val('');
                $("#searchimeino").val('');
                $("#searchmacaddress").val('');
                $("#searchcreator").val('');
                $("#searchcreatedate1").val('');
                $("#searchcreatedate2").val('');
                doDefCombo(comboData, 1 ,'searchstatus', 'M', 'f_multiCombo');
               doGetCombo('/logistics/assetmng/selectTypeList.do', '1199', 'all','searchtype', 'M' , 'f_TypeMultiCombo'); //Type 리스트 조회
                     
                doGetCombo('/logistics/assetmng/selectDealerList.do', '1', '','searchdealer', 'S' , '');//dealer 
                doGetCombo('/common/selectCodeList.do', '112', '','searchcolor', 'S' , ''); //Color 리스트 조회
                doGetCombo('/common/selectCodeList.do', '112', '','mastercolor', 'S' , ''); //Color 리스트 조회
                doGetCombo('/common/selectCodeList.do', '111', '','mastertype', 'S' , ''); //Type 리스트 조회
                doGetCombo('/common/selectCodeList.do', '108', '','searchcategory', 'S' , ''); //category 리스트 조회
                doGetCombo('/common/selectCodeList.do', '108', '','mastercategory', 'S' , ''); //category 리스트 조회  
                doGetCombo('/logistics/assetmng/selectDealerList.do', '1', '','masterdealer', 'S' , '');//dealer 리스트 조회
                doGetCombo('/logistics/assetmng/selectBrandList.do', '', '','masterbrand', 'S' , '');//brand 리스트 조회
                doGetComboSepa('/common/selectBranchCodeList.do', '3' , ' - ' , '','searchbranchid', 'S' , ''); //청구처 리스트 조회
                doDefCombo('', '' ,'searchdepartment', 'M', 'f_deptmultiCombo');
            });
               
         $("#insert").click(function(){
           div="N";
           $("#detailHead").text("AssetMng Information Registration");
           fn_setVisiable(div);
           destory(AddDetailGrid);
           $("#masterWindow").show();
           $("#Details_info").hide();
           $("#Update_info").hide();
           $("#CopyAssetInfo").hide();         
           $("#trnasInfo").hide(); 
           $("#saveTrnsBtn").hide(); 
           $("#saveStatusBtn").hide(); 
           $("#returnTrnsBtn").hide();
           AddDetailGrid = AUIGrid.create("#addDetail_grid", insDetailLayout,"", gridoptions);
          // $("#Insert_info").click();
          });
         
         $("#savePopbtn").click(function(){
                div="N";
                if (valiedcheck()){
                assetsaveAjax(div);  
                }
         });
         
         $("#Insert_info").click(function(){
            $("#add_info_div").show(); 
            destory(AddDetailGrid);
            AddDetailGrid = AUIGrid.create("#addDetail_grid", insDetailLayout,"", gridoptions);
            AUIGrid.resize(AddDetailGrid,942, 280);
           // AddDetailAUIGrid(insDetailLayout);           
     });
         
         
         $("#Details_info").click(function(){
             div="viewitem";
             destory(detailGrid);
             $("#DtatilGrid_div_tap").show();  
             var selectedItem = AUIGrid.getSelectedIndex(myGridID);
             detailGrid  = GridCommon.createAUIGrid("#DtatilGrid_div", detailLayout,"", gridoptions);
             getDetailAssetListAjax(selectedItem[0],div);
             if("C"==copyDetails){
                 $("#CopyAssetInfo2").show();
                 $("#a2").show();           	 
             }else{
                 $("#CopyAssetInfo2").hide();     
                 $("#a2").hide();
             }    
             
     });
         //Update_info tap
         $("#Update_info").click(function(){
             AUIGrid.destroy(upitemGrid);
             div="upitem"
             $("#Updadte_div_tap").show();
             var selectedItem = AUIGrid.getSelectedIndex(myGridID);
             $("#addassetid").val(AUIGrid.getCellValue(myGridID ,selectedItem[0],'assetid'));
             var itemtype = AUIGrid.getCellValue(myGridID ,selectedItem[0],'typeid');
             //upitemGrid  = GridCommon.createAUIGrid("#UpDetail_div", updateLayout,"", gridoptions);
             upitemGrid  = GridCommon.createAUIGrid("#UpDetail_div", updateLayout,"", subgridpros);
             getDetailAssetListAjax(selectedItem[0],div);    
             fn_srvMembershipList(itemtype);
             fn_BrandList();             
     });
         
           
          $("#item_info_add").click(function(){
              $("#AddItemForm")[0].reset();
             $("#regUpdateWindow").show(); 
             var selectedItem = AUIGrid.getSelectedIndex(myGridID);
             var itemtype = AUIGrid.getCellValue(myGridID ,selectedItem[0],'typeid');
             doGetCombo('/logistics/assetmng/selectTypeList.do', itemtype, '','additemtype', 'S' , ''); //Type 리스트 조회
             doGetCombo('/logistics/assetmng/selectBrandList.do', '', '','additemBrand', 'S' , '');//brand 리스트 조회
             //addItemGrid  = GridCommon.createAUIGrid("#AddItem_div", additemLayout,"", gridoptions);    
     });
               
         
      $("#detail_info_add").click(function(){
         $("#detailForm")[0].reset();
        $("#regDetailWindow").show();
      
       });
      
  
         
         $("#update").click(function(){
             div="U";
             $("#Details_info").hide();
             $("#Insert_info").hide();
             $("#CopyAssetInfo").hide();
             $("#trnasInfo").hide();
             $("#detailHead").text("AssetMng Information Modification");
             selectedItem = AUIGrid.getSelectedIndex(myGridID);
             if (selectedItem[0] > -1){
                 fn_assetDetail(selectedItem[0]);
                 fn_setVisiable(div);
                 $("#masterWindow").show();
                 $("#trigger").trigger("click");
             }else{
             Common.alert('Choice Data please..');
             }
        
         });
         
         $("#copyAssetOpen").click(function(){
             div="V";
             copyDetails="C";
             $("#detailHead").text("Copy/Duplicate Informaton");
             selectedItem = AUIGrid.getSelectedIndex(myGridID);
             if (selectedItem[0] > -1){
                 fn_assetDetail(selectedItem[0]);
                 fn_setVisiable(div);
                 $("#CopyAssetInfo").show();
                 $("#masterWindow").show();
                 $("#Details_info").show();
                 $("#trigger").trigger("click");
                 $("#Insert_info").hide();
                 $("#Update_info").hide();
                 $("#cancelPopbtn").hide();
                 $("#saveStatusBtn").hide();
                 $("#trnasInfo").hide();
                 $("#statusInfo").hide();
                 $("#a1").show();
                 
             }else{
             Common.alert('Choice Data please..');
             }
        
         });
         
         $("#copybtn").click(function(){
             
            div="V";
            regex = /[^0-9]/gi;
             v = $("#copyquantity").val();
             if (regex.test(v)) {
                /*  var nn = v.replace(regex, '');
                 $("#copyquantity").val(v.replace(regex, ''));
                 $("#copyquantity").focus();
                 return; */
                 Common.alert('Please Check Input Number.');
             } 
            var selectedItems = AUIGrid.getSelectedItems(myGridID);
            for(i=0; i<selectedItems.length; i++) {
             url="/logistics/assetmng/copyAsset.do?assetid="+selectedItems[i].item.assetid+"&copyquantity="+v;

             f_others(url, div);
            }
         });
         
         $("#copybtn2").click(function(){
             
             div="V";
             regex = /[^0-9]/gi;
              v = $("#copyquantity2").val();
              if (regex.test(v)) {
                 /*  var nn = v.replace(regex, '');
                  $("#copyquantity").val(v.replace(regex, ''));
                  $("#copyquantity").focus();
                  return; */
                  Common.alert('Please Check Input Number.');
              } 
             var selectedItems = AUIGrid.getSelectedItems(myGridID);
             for(i=0; i<selectedItems.length; i++) {
              url="/logistics/assetmng/copyAsset.do?assetid="+selectedItems[i].item.assetid+"&copyquantity="+v;

              f_others(url, div);
             }
          });

         
         $("#updatePopbtn").click(function(){
                div="U";
                if (valiedcheck()){
                assetsaveAjax(div);
                }
         });
          
         $("#delete").click(function(){
             div="D";
             selectedItem = AUIGrid.getSelectedIndex(myGridID);
              if (selectedItem[0] > -1){
                 fn_assetDetail(selectedItem[0]);
                 //assetsaveAjax(div);
            	  if(Common.confirm("<spring:message code='sys.common.alert.delete'/>", function(){     
                      
                      $("#prefix").attr("disabled", false);
                      
                     Common.ajax("POST", "/logistics/assetmng/deleteAssetMng.do", param= $("#masterForm").serializeJSON(), function(result){
                    	 Common.alert(result.msg);
                       
                     }
                     , function(jqXHR, textStatus, errorThrown){
                         try {
                             console.log("Fail Status : " + jqXHR.status);
                             console.log("code : "        + jqXHR.responseJSON.code);
                             console.log("message : "     + jqXHR.responseJSON.message);
                             console.log("detailMessage : "  + jqXHR.responseJSON.detailMessage);
                             }
                         catch (e)
                         {
                           console.log(e);
                         }
                         alert("Fail : " + jqXHR.responseJSON.message);
   
                     });

                 }));          
             }else{
             Common.alert('Choice Data please..');
             } 
         });
         
         $("#transAssetOpen").click(function(){
             var selectedItem = AUIGrid.getSelectedIndex(myGridID);
             if (selectedItem[0] > -1){
                       var stusId=AUIGrid.getCellValue(myGridID ,selectedItem[0] ,'stusid');
                      doGetComboSepa('/common/selectBranchCodeList.do', '9' , ' - ' , '','trnsbranchid', 'S' , ''); //청구처 리스트 조회
                      doDefCombos('', '' ,'transdepartment', 'S', '');
                      //doGetCombo(comUrl, '11', '','categoryPop', 'S' , ''); 
                 if(stusId=="1"){
                     div="V";              
                     $("#detailHead").text("Transfer Asset");
                     fn_setVisiable(div); 
                     fn_assetDetail(selectedItem[0]);
                      $("#masterWindow").show();
                      $("#Details_info").show();
                      $("#Insert_info").hide();
                      $("#Update_info").hide();
                      $("#CopyAssetInfo").hide();
                      $("#cancelPopbtn").hide();
                      //$("#ViewTrnsBtn").show();
                      $("#transH3_01").show();
                      $("#saveTrnsBtn").show();
                      $("#returnTrnsBtn").hide();
                      $("#saveStatusBtn").hide();
                      $("#trnasInfo").show();
                      $("#statusInfo").hide();
                     
                 }else{
                     Common.alert('This asset is not active. Transfer asset is disallowed.');
                 }
             }else{
             Common.alert('Choice Data please..');
             }
         });
         
         $("#returnAssetOpen").click(function(){
             var selectedItem = AUIGrid.getSelectedIndex(myGridID);
             if (selectedItem[0] > -1){
                 var currbrnchid=AUIGrid.getCellValue(myGridID ,selectedItem[0] ,'currbrnchid');
                 var currdeptid=AUIGrid.getCellValue(myGridID ,selectedItem[0] ,'currdeptid');
                          //doGetComboSepa('/common/selectBranchCodeList.do', '3' , ' - ' , '','trnsbranchid', 'S' , ''); //청구처 리스트 조회
                          //doDefCombos('', '' ,'transdepartment', 'S', '');
                          //doGetCombo(comUrl, '11', '','categoryPop', 'S' , ''); 
                 if(currbrnchid == '42' && currbrnchid == '38'){
                     Common.alert('This asset is already at IT Department store.');
                 }else{
                     div="V";              
                     $("#detailHead").text("Return Asset");
                     fn_setVisiable(div); 
                     fn_assetDetail(selectedItem[0]);
                      $("#masterWindow").show();
                      $("#Details_info").show();
                      $("#Insert_info").hide();
                      $("#Update_info").hide();
                      $("#CopyAssetInfo").hide();
                      $("#cancelPopbtn").hide();
                      //$("#ViewTrnsBtn").show();
                      $("#transH3_01").show();
                      $("#saveTrnsBtn").hide();
                      $("#returnTrnsBtn").show();
                      $("#saveStatusBtn").hide();
                      $("#trnasInfo").hide();
                      $("#statusInfo").hide();
                 }
             }else{
             Common.alert('Choice Data please..');
             }
         });
         $("#statusAssetOpen").click(function(){
             $("#status").val("");
             $("#statusremark").val("");
             var selectedItem = AUIGrid.getSelectedIndex(myGridID);
             if (selectedItem[0] > -1){
                 var currbrnchid=AUIGrid.getCellValue(myGridID ,selectedItem[0] ,'currbrnchid');
                 var currdeptid=AUIGrid.getCellValue(myGridID ,selectedItem[0] ,'currdeptid');
                          //doGetComboSepa('/common/selectBranchCodeList.do', '3' , ' - ' , '','trnsbranchid', 'S' , ''); //청구처 리스트 조회
                          //doDefCombos('', '' ,'transdepartment', 'S', '');
                          //doGetCombo(comUrl, '11', '','categoryPop', 'S' , ''); 
                 if(currbrnchid == '42' && currbrnchid == '38'){
                     Common.alert('Only IT Department Store asset can be');
                 }else{
                     div="V";              
                     $("#detailHead").text("Asset - Report Obsolete/Lost");
                     fn_setVisiable(div); 
                     fn_assetDetail(selectedItem[0]);
                      $("#masterWindow").show();
                      $("#saveStatusBtn").show();
                      $("#Details_info").show();
                      $("#Insert_info").hide();
                      $("#Update_info").hide();
                      $("#CopyAssetInfo").hide();
                      $("#cancelPopbtn").hide();
                      //$("#ViewTrnsBtn").show();
                      $("#transH3_01").show();
                      $("#saveTrnsBtn").hide();
                      $("#returnTrnsBtn").hide();
                      $("#trnasInfo").hide();
                      $("#statusInfo").show();
                     
                 }
             }else{
             Common.alert('Choice Data please..');
             }
         });
         $("#ViewMoveTrns").click(function(){
             destory(assetMoveTrnsGrid);
             assetMoveTrnsGrid  = GridCommon.createAUIGrid("assetMoveTrnsGrid", asstMoveTrnsLayout,"", subgridpros);
             $("#asstMoveTrnsDiv").show();  
                searchAssetMoveTransacton();
         });
     
         $("#saveTrnsBtn").click(function(){
             var branch = $("#trnsbranchid").val();
             var dept = $("#transdepartment").val();
             if(null == branch || ''==branch){
                 Common.alert("Please Select Branch.");
                 return false;
             }else if( branch == "42"){
                 if(null == dept || ''==dept){
                 Common.alert("Please Select Current Department.");
                 return false;
                 }
             }
             $("#cardTypeId").val("TR");
             saveTrns();
             
         });
         $("#saveStatusBtn").click(function(){
             var status = $("#status").val();
             var statusremark = $("#statusremark").val();
             if(null == status || ''==status){
                 Common.alert("Please Select Status.");
                 return false;
             }
             if("7"==status){
                 $("#cardTypeId").val("OB");
             }else if("67"==status){
                 $("#cardTypeId").val("LS");
             }else{
                 $("#cardTypeId").val("DE");
             }
             saveStatus();
             
         });
         $("#returnTrnsBtn").click(function(){
             $("#cardTypeId").val("RT");
             saveTrnsRe();
             
         });
         
         $("#transBulkAssetOpen").click(function(){
             destory(assetMoveTrnsBulkGrid);
             assetMoveTrnsBulkGrid  = GridCommon.createAUIGrid("assetMoveTrnsBulkGrid", bulkLayout,"", subgridpros);
             AUIGrid.resize(assetMoveTrnsBulkGrid,1205,300);
             doGetComboSepa('/common/selectBranchCodeList.do', '9' , ' - ' , '','trnsbranchidFrom', 'S' , ''); //청구처 리스트 조회
             doGetComboSepa('/common/selectBranchCodeList.do', '9' , ' - ' , '','trnsbranchidTo', 'S' , ''); //청구처 리스트 조회
             doDefCombos('', '' ,'transdepartmentFrom', 'S', '');
             doDefCombos('', '' ,'transdepartmentTo', 'S', '');
             $("#asstMoveTrnsBulkDiv").show();  
               // searchAssetMoveTransacton();
         });
         $("#transAsset").click(function(){
             var selectedItem = AUIGrid.getSelectedIndex(assetMoveTrnsBulkGrid);
             //var tmp = AUIGrid.getCellValue(assetMoveTrnsBulkGrid ,selectedItem[0],'assetid');
             var branchF = $("#trnsbranchidFrom").val();
             var branchT = $("#trnsbranchidTo").val();
             var deptF = $("#transdepartmentFrom").val();
             var deptT = $("#transdepartmentTo").val();
             if(null == branchF || ''==branchF){
                 Common.alert("Please Select Transfer From Branch.");
                 return false;
             }else if( branchF == "42"){
                 if(null == deptF || ''==deptF){
                 Common.alert("Please Select Transfer From Department.");
                 return false;
                 }
             }
             if(null == branchT || ''==branchT){
                 Common.alert("Please Select Transfer To Branch.");
                 return false;
             }else if( branchT == "42"){
                 if(null == deptT || ''==deptT){
                 Common.alert("Please Select Transfer To Department.");
                 return false;
                 }
             }
             if(branchF == branchT){
                 if(branchT=="42"){
                     Common.alert("Same department is disallowed.");
                     return false;
                 }else{
                     Common.alert("Same branch is disallowed.");
                     return false;
                 }
                 
             }
             var assetid=AUIGrid.getCellValue(assetMoveTrnsBulkGrid ,selectedItem[0],'assetid');
             var asset = $("#masterassetidBulk").val(assetid);
             if(null == asset || ''==asset || 0>selectedItem[0]){
                 Common.alert('Choice Data please..');
                  return false;
             }
             $("#cardTypeIdBulk").val("TR");
             saveTrnsBulk();
             
         });
        $(".numberAmt").keyup(function(e) {
            regex = /[^.0-9]/gi;
            v = $(this).val();
            if (regex.test(v)) {
                var nn = v.replace(regex, '');
                $(this).val(v.replace(regex, ''));
                $(this).focus();
                return;
            }
         });
        $("#copyquantity").keyup(function(e){
            regex = /[^0-9]/gi;
            v = $(this).val();
            if (regex.test(v)) {
                var nn = v.replace(regex, '');
                $(this).val(v.replace(regex, ''));
                $(this).focus();
                return;
            }
            
        });  
        
        $('#masterpurchaseamount').keypress(function() {
            if (event.which == '13') {
                var findStr=".";
                var sublen;
                var prices = $("#masterpurchaseamount").val();
                var priceslen=prices.length;
                //alert("????"+prices.indexOf(findStr));
                if (prices.indexOf(findStr) > 0) {  
                  sublen= prices.indexOf('.');
                  sublen=sublen+1;
                  var sums = priceslen - sublen;
                //  alert("sums :  "+sums);
                  if(sums == 0 ){
                      $("#masterpurchaseamount").val(prices+"00");  
                  }else if(sums == 1 ){
                      $("#masterpurchaseamount").val(prices+"0");  
                  }else if(sums == 2){
                        
                  }else{
                      Common.alert("Please enter only the second decimal place.");
                      $("#masterpurchaseamount").val("");
                  }
                 
                  }else if(prices.indexOf(findStr) == 0){
                      Common.alert('You can not enter decimal numbers first.');
                      $("#masterpurchaseamount").val("");
                  }else{
                    //  alert('Not Found!!');
                      $("#masterpurchaseamount").val($.number(prices,2));  
                  } 
    
            }
        }); 
        
        $("#download").click(function(){
        	GridCommon.exportTo("main_grid_wrap", 'xlsx', "Asset List");
        });
        
        /*$('#exportTo').click(function() {
            
        	var selectedItem = AUIGrid.getSelectedIndex(myGridID);
        	
        	if (selectedItem[0] > -1){
        		   	
            // 그리드의 숨겨진 칼럼이 있는 경우, 내보내기 하면 엑셀에 아예 포함시키지 않습니다.
            // 다음처럼 excelProps 에서 exceptColumnFields 을 지정하십시오.
            
            var excelProps = {
                    
                //fileName     : $("#adjno").val()+"_"+$("#txtlocCode").text(),
                fileName     : "AssetList",
                //sheetName : $("#txtlocCode").text(),
                sheetName : "Asset" ,
                //exceptColumnFields : ["cntQty"], // 이름, 제품, 컬러는 아예 엑셀로 내보내기 안하기.
                
                 //현재 그리드의 히든 처리된 칼럼의 dataField 들 얻어 똑같이 동기화 시키기
               exceptColumnFields : AUIGrid.getHiddenColumnDataFields(myGridID) 
            };
            
            //AUIGrid.exportToXlsx(myGridIDHide, excelProps);
            AUIGrid.exportToXlsx(myGridID, excelProps);
            //GridCommon.exportTo("grid_wrap", "xlsx", "test");
            
            }else{
                Common.alert('No item to export.');
            }

        });*/
        
       $('#currentAsset').click(function() {
            
            $("#reportPDFForm #reportFileName").val('/logistics/BranchDeptCurrentAsset.rpt');

            //report 호출
            var option = {
                    isProcedure : false, // procedure 로 구성된 리포트 인경우 필수.
            };
            
            Common.report("reportPDFForm", option);
       
        });
     
    });
    
    
//     function getAssetListAjax() {
//         var param = $('#searchForm').serialize();
//         $.ajax({
//             type : "POST",
//             url : "/logistics/assetmng/assetList.do?" + param,
//             //url : "/stock/StockList.do",
//             //data : param,
//             dataType : "json",
//             contentType : "application/json;charset=UTF-8",
//             success : function(data) {
//                 var gridData = data             
            
//                 AUIGrid.setGridData(myGridID, gridData.data);
//             },
//             error : function(jqXHR, textStatus, errorThrown) {
//                 alert("실패하였습니다.");
//             },
           
//         });
//     }
    
     function getAssetListAjax() {
        
         var param = $('#searchForm').serialize();
         var url = "/logistics/assetmng/assetList.do";
            Common.ajax("GET" , url , param , function(data){
             var gridData = data             
                
             AUIGrid.setGridData(myGridID, gridData.data);
                
            });

     }
    

    
     function getDetailAssetListAjax(rowid,div) {
         var assetid=AUIGrid.getCellValue(myGridID ,rowid,'assetid');
         var param = "?assetid="+assetid; 
         $.ajax({
            type : "POST",
            url : "/logistics/assetmng/selectDetailList.do" + param,
            dataType : "json",
            contentType : "application/json;charset=UTF-8",
            success : function(data) {
                 var gridData = data             
  
                 //f_dtail_info(gridData); 
                 if(div == "viewitem"){
                    
                  AUIGrid.setGridData(detailGrid, gridData.data);
                  AUIGrid.resize(detailGrid);
                 }else{
                     AUIGrid.setGridData(upitemGrid, gridData.data);      
                     AUIGrid.resize(upitemGrid);
                 }
                hideModal(); 
            },
            error : function(jqXHR, textStatus, errorThrown) {
                alert("실패하였습니다.");
            },
           
        }); 
    }
    function assetsaveAjax(div) {
        var url;
        var key;
        var param;
        //param= $("#masterForm").serializeJSON();
         /* param = { 
                masterAddForm : $("#masterForm").serializeJSON(),
                 detailAddForm : GridCommon.getEditData(AddDetailGrid)
               };   */
        if(div=="N"){
            param = GridCommon.getEditData(AddDetailGrid);
            param.form = $("#masterForm").serializeJSON();
        }else if(div=="U"){
            param= $("#masterForm").serializeJSON();
        }else if(div=="D"){
            param= $("#masterForm").serializeJSON();
        }else if(div=="MI"){
            param = GridCommon.getEditData(upitemGrid);
        }else if(div=="EI"){
            param = GridCommon.getEditData(upitemGrid);
        }

       if(div=="N"){
           url="/logistics/assetmng/insertAssetMng.do";    
       }else if(div=="U"){ //마스터 인서트
           url="/logistics/assetmng/motifyAssetMng.do";
       }else if(div=="D"){ //딜리트
           url="/logistics/assetmng/deleteAssetMng.do";
       }else if(div=="MI"){
           url="/logistics/assetmng/addItemAssetMng.do";
       }else if(div=="RI"){
           url="/logistics/assetmng/RemoveItemAssetMng.do";
       }else if(div=="EI"){
           url="/logistics/assetmng/updateItemAssetMng.do";
       }    
       Common.ajax("POST",url,param,function(result){
           Common.alert(result.msg);
           if(div=="AI"){
               
           }else{
           $("#masterWindow").hide();              
           }
           $("#search").trigger("click");
          
       });
   } 
    
   function f_others(url, v){
//            $.ajax({
//                type : "POST",
//                url : url,
//                dataType : "json",
//                contentType : "application/json;charset=UTF-8",
//                success : function(result) {
//                 Common.alert(result.msg);

//                   // f_info(data, v);
//                },
//                error : function(jqXHR, textStatus, errorThrown) {
//                    alert("실패하였습니다.");
//                }
//            });

       Common.ajax("POST" , url , '' , function(data){
           Common.alert(data.msg);
              
          });   
   }
   
      
    function fn_assetDetail(rowid){
        $("#masterassetid").val(AUIGrid.getCellValue(myGridID ,rowid,'assetid'));
        $("#masterstatus").val(AUIGrid.getCellValue(myGridID ,rowid,'name2'));
        $("#masterbreanch").val(AUIGrid.getCellValue(myGridID ,rowid,'branch'));
        $("#masterdepartment").val(AUIGrid.getCellValue(myGridID ,rowid,'department'));
        $("#masteruser").val(AUIGrid.getCellValue(myGridID ,rowid,'username2'));
        $("#mastercategory").val(AUIGrid.getCellValue(myGridID ,rowid,'ctgryid'));
        $("#mastertype").val(AUIGrid.getCellValue(myGridID ,rowid,'typeid'));
        $("#mastermodelname").val(AUIGrid.getCellValue(myGridID ,rowid,'name1'));
        $("#mastercolor").val(AUIGrid.getCellValue(myGridID ,rowid,'colorid'));
        $("#masterinvoiceno").val(AUIGrid.getCellValue(myGridID ,rowid,'invcno'));
        $("#masterdealer").val(AUIGrid.getCellValue(myGridID ,rowid,'dealerid'));
        $("#masterpurchasedate").val(AUIGrid.getCellValue(myGridID ,rowid,'purchsdt'));
        $("#masterbrand").val(AUIGrid.getCellValue(myGridID ,rowid,'brandid'));
        $("#masterpurchaseamount").val(AUIGrid.getCellValue(myGridID ,rowid,'purchsamt'));
        $("#masterrefno").val(AUIGrid.getCellValue(myGridID ,rowid,'refno'));
        $("#masterserialno").val(AUIGrid.getCellValue(myGridID ,rowid,'serialno'));
        $("#masterwarrantyno").val(AUIGrid.getCellValue(myGridID ,rowid,'wrantyno'));
        $("#mastermacaddress").val(AUIGrid.getCellValue(myGridID ,rowid,'macaddr'));
        $("#masterimeino").val(AUIGrid.getCellValue(myGridID ,rowid,'imeino'));
        $("#masterremark").val(AUIGrid.getCellValue(myGridID ,rowid,'assetrem'));
        //$("#masterWindow").show();
    }
    function fn_assetDetailCancel(){
        $( "#masterWindow" ).hide();
    }
    
    function f_showModal(){
        $.blockUI.defaults.css = {textAlign:'center'}
        $('div.SalesWorkDiv').block({
                message:"<img src='/resources/images/common/CowayLeftLogo.png' alt='Coway Logo' style='max-height: 46px;width:160px' /><div class='preloader'><i id='iloader'>.</i><i id='iloader'>.</i><i id='iloader'>.</i></div>",
                centerY: false,
                centerX: true,
                css: { top: '300px', border: 'none'} 
        });
    }
    function hideModal(){
        $('div.SalesWorkDiv').unblock();
        
    }
//멀티 셀렉트 세팅 함수들    
     function f_multiCombo() {
         
         $(function() {
             $('#searchstatus').change(function() {

             }).multipleSelect({
                 selectAll : true, // 전체선택 
                 width : '80%'
             });       
         });
     }
     
    function f_deptmultiCombo() {

        $(function() {

            $('#searchdepartment').change(function() {

            }).multipleSelect({
                selectAll : true,
                width : '80%'
            }).multipleSelect("disable");

        });
    }
       function f_DepartmentList() {
            $('#searchdepartment')
            .multipleSelect()
            .multipleSelect("enable")
            .multipleSelect("checkAll");
        }
       
       function f_TypeMultiCombo() {
           $(function() {
                 $('#searchtype').change(function() {

                 }).multipleSelect({
                     selectAll : true,
                     width : '80%'
                 }).multipleSelect("disable");      
             
             });       
       }
    

    function fn_setVisiable(div) {
        if (div == "V") {
            $("#masterstatus").prop('readonly', true);
            $("#masterbreanch").prop('readonly', true);
            $("#masterdepartment").prop('readonly', true);
            $("#masteruser").prop('readonly', true);
            $("#mastercategory").prop('disabled', true);
            $("#mastertype").prop('disabled', true);
            $("#mastermodelname").prop('readonly', true);
            $("#mastercolor").prop('disabled', true);
            $("#masterinvoiceno").prop('readonly', true);
            $("#masterdealer").prop('disabled', true);
            $("#masterpurchasedate").prop('disabled', true);
            $("#masterbrand").prop('disabled', true);
            $("#masterpurchaseamount").prop('readonly', true);
            $("#masterrefno").prop('readonly', true);
            $("#masterserialno").prop('readonly', true);
            $("#masterwarrantyno").prop('readonly', true);
            $("#mastermacaddress").prop('readonly', true);
            $("#masterimeino").prop('readonly', true);
            $("#masterremark").prop('readonly', true);
            $("#trinserthide1").show();
            $("#trinserthide2").show();
            $("#savePopbtn").hide();
            $("#saveTrnsBtn").hide();
             $("#returnTrnsBtn").hide();
            $("#updatePopbtn").hide();
            $("#saveStatusBtn").hide();
            $("#statusInfo").hide();
            $("#a1").hide();
        } else if (div == "U") {
            $("#masterstatus").prop('readonly', true);
            $("#masterbreanch").prop('readonly', true);
            $("#masterdepartment").prop('readonly', true);
            $("#masteruser").prop('readonly', false);
            $("#mastercategory").prop('disabled', true);
            $("#mastertype").prop('disabled', true);
            $("#mastermodelname").prop('readonly', false);
            $("#mastercolor").prop('disabled', false);
            $("#masterinvoiceno").prop('readonly', false);
            $("#masterdealer").prop('disabled', false);
            $("#masterpurchasedate").prop('disabled', false);
            $("#masterbrand").prop('disabled', false);
            $("#masterpurchaseamount").prop('readonly', false);
            $("#masterrefno").prop('readonly', false);
            $("#masterserialno").prop('readonly', false);
            $("#masterwarrantyno").prop('readonly', false);
            $("#mastermacaddress").prop('readonly', false);
            $("#masterimeino").prop('readonly', false);
            $("#masterremark").prop('readonly', false);
            $("#trinserthide1").show();
            $("#trinserthide2").show();
            $("#savePopbtn").hide();
            $("#saveTrnsBtn").hide();
            $("#returnTrnsBtn").hide();
            $("#saveStatusBtn").hide();
            $("#updatePopbtn").show();
            $("#statusInfo").hide();
            $("#a1").hide();
            $("#Update_info").show();
        } else if (div == "N") {
            $('#masterForm')[0].reset();
            $("#trinserthide1").hide();
            $("#trinserthide2").hide();
            $("#mastercategory").prop('disabled', false);
            //$("#mastertype").prop('disabled', false);
            $("#mastermodelname").prop('readonly', false);
            $("#mastercolor").prop('disabled', false);
            $("#masterinvoiceno").prop('readonly', false);
            $("#masterdealer").prop('disabled', false);
            $("#masterpurchasedate").prop('disabled', false);
            $("#masterbrand").prop('disabled', false);
            $("#masterpurchaseamount").prop('readonly', false);
            $("#masterrefno").prop('readonly', false);
            $("#masterserialno").prop('readonly', false);
            $("#masterwarrantyno").prop('readonly', false);
            $("#mastermacaddress").prop('readonly', false);
            $("#masterimeino").prop('readonly', false);
            $("#masterremark").prop('readonly', false);
            $("#savePopbtn").show();
            $("#updatePopbtn").hide();
            $("#insertdetail").show();
            $("#statusInfo").hide();
            $("#a1").hide();
            $("#Insert_info").show();
            combReset();
        }
    }
    function combReset() {
        doGetCombo('/logistics/assetmng/selectBrandList.do', '', '','masterbrand', 'S', '');//brand
        doGetCombo('/logistics/assetmng/selectBrandList.do', '', '','insdetailBrand', 'S', '');//detailbrand
        doGetCombo('/common/selectCodeList.do', '111', '', 'mastertype', 'S',''); //Type 리스트 조회
        doGetCombo('/common/selectCodeList.do', '112', '', 'mastercolor', 'S',''); //Color 리스트 조회
        doGetCombo('/logistics/assetmng/selectDealerList.do', '1', '','masterdealer', 'S', '');//dealer 
    }

    function valiedcheck() {
        if ($("#mastercategory").val() == "") {
            Common.alert("Please select the category.");
            $("#mastercategory").focus();
            return false;
        }
        if ($("#mastertype").val() == "") {
            Common.alert("Please select the type.");
            $("#mastertype").focus();
            return false;
        }
        if ($("#mastermodelname").val() == "") {
            Common.alert("Please key in the model name.");
            $("#mastermodelname").focus();
            return false;
        }
        if ($("#mastercolor").val() == "") {
            Common.alert("Please select the color.");
            $("#mastercolor").focus();
            return false;
        }
        if ($("#masterinvoiceno").val() == "") {
            Common.alert("Please key in the invoice.");
            $("#masterinvoiceno").focus();
            return false;
        }
        if ($("#masterdealer").val() == "") {
            Common.alert("Please select the Dealer.");
            $("#masterdealer").focus();
            return false;
        }
        if ($("#masterpurchasedate").val() == "") {
            Common.alert("Please select purchase date");
            $("#masterpurchasedate").focus();
            return false;
        }
        if ($("#masterbrand").val() == "") {
            Common.alert("Please select the brand.");
            $("#masterbrand").focus();
            return false;
        }
        if ($("#masterpurchaseamount").val() == "") {
            Common.alert("Please key in purchase Amount.");
            $("#masterpurchaseamount").focus();
            return false;
        }

        return true;
    }
    function detailvaliedcheck() {
        if ($("#insdetailtype").val() == "") {
            Common.alert("Please select the details type.");
            $("#insdetailtype").focus();
            return false;
        }
        if ($("#insdetailBrand").val() == "") {
            Common.alert("Please select the details brand.");
            $("#insdetailBrand").focus();
            return false;
        }
        if ($("#insdetailmodel").val() == "") {
            Common.alert("Please key in the details model name.");
            $("#insdetailmodel").focus();
            return false;
        }

        return true;
    }
    
       function itemvaliedcheck(div) {
         if(div==""){
             if ($("#additemtype").val() == "") {
                    Common.alert("Please select the details type.");
                    $("#additemtype").focus();
                    return false;
                }
                if ($("#additemBrand").val() == "") {
                    Common.alert("Please select the details brand.");
                    $("#additemBrand").focus();
                    return false;
                }
                if ($("#additemmodel").val() == "") {
                    Common.alert("Please key in the details model name.");
                    $("#additemmodel").focus();
                    return false;
                } 
         }else if(div=="MI"){
           if ($("#multyitemname").val() == "") {
                  Common.alert("Please key in the details model name.");
                  $("#multyitemname").focus();
                  return false;
              } 
         }
            return true;
        }
    
    
    

    /*----------------------------------------   셀렉트박스 이벤트 시작 ---------------------------------------------------- */
    function getComboRelays(obj, value, tag, selvalue) {
        var robj = '#' + obj;
        $(robj).attr("disabled", false);
        if (value == "42") {
            doGetComboSelBox('/logistics/assetmng/selectDepartmentList.do', tag, value, selvalue, obj, 'M', 'f_DepartmentList'); //Department 리스트 조회    
        }else{
              $('#searchdepartment').multipleSelect("disable");  
        }
    }
    function getComboRelayTrns(obj, value, tag, selvalue) {
        var robj = '#' + obj;
        $(robj).attr("disabled", false);
        if (value == "42") {
            doGetComboSelBox('/logistics/assetmng/selectDepartmentList.do', tag, value, selvalue, obj, 'S', ''); //Department 리스트 조회    
        }else{
            $(robj).val("");
            $(robj).attr("disabled", true);
        }
        if(obj=="transdepartmentFrom"){
             if(value != "42"){
                searchAssetBulkList(value,'');
             }
        }
    }
 
    function getComboRelayTrnsBulk(obj, value, tag, selvalue) {
             var brachId=$('#trnsbranchidFrom').val();
             if(brachId == "42"){
                 if(null == value || ''==value){
                 Common.alert("Please Select Transfer From Department.");
                 return false;
                 }
             }
             searchAssetBulkList(brachId,value);
    }
 
    
       function getComboRelayss(obj, value, tag, selvalue) {
            var robj = '#' + obj;
            $(robj).attr("disabled", false);    
            doGetComboSelBox('/logistics/assetmng/selectTypeList.do', tag , value , selvalue,obj, 'S', ''); //detail type 리스트 조회                
        }

    function doGetComboSelBox(url, groupCd, codevalue, selCode, obj, type,
            callbackFn) {
        $.ajax({
            type : "GET",
            url : url,
            data : {
                groupCode : codevalue
            },
            dataType : "json",
            contentType : "application/json;charset=UTF-8",
            success : function(data) {
                var rData = data;
                doDefCombos(rData, selCode, obj, type, callbackFn);
            },
            error : function(jqXHR, textStatus, errorThrown) {
                alert("Draw ComboBox['" + obj
                        + "'] is failed. \n\n Please try again.");
            },
            complete : function() {
            }
        });
    };

    function doDefCombos(data, selCode, obj, type, callbackFn) {
        var targetObj = document.getElementById(obj);
        var custom = "";
        for (var i = targetObj.length - 1; i >= 0; i--) {
            targetObj.remove(i);
        }
        obj = '#' + obj;
        if (type && type != "M") {
            custom = (type == "S") ? eTrusttext.option.choose
                    : ((type == "A") ? eTrusttext.option.all : "");
            $("<option />", {
                value : "",
                text : custom
            }).appendTo(obj);
        } else {
            $(obj).attr("multiple", "multiple");
        }

        $.each(data, function(index, value) {
            //CODEID , CODE , CODENAME ,,description
            if (selCode == data[index].codeId) {
                $('<option />', {
                    value : data[index].codeId,
                    text : data[index].codeName
                }).appendTo(obj).attr("selected", "true");
            } else {
                $('<option />', {
                    value : data[index].codeId,
                    text : data[index].codeName
                }).appendTo(obj);
            }
        });
        if(obj=="#transdepartmentFrom" ||  obj=="#transdepartmentTo"  ||  obj=="#transdepartment" ){
        //$("#selBox option:eq(2)").before("<option ;value='38'>** IT Department Store **</option>");
        var setVal=obj +" option:eq(1)"
        $(setVal).before("<option value='38'>** IT Department Store **</option>");
        }
        if (callbackFn) {
            var strCallback = callbackFn + "()";
            eval(strCallback);
        }
    };

    /* -----------------------------------------------  셀렉트 박스 이벤트 끝 -------------------------------------------------------------------- */

    function typeallchek() {
        var typesize = $("#searchtype option").size();
        for (var int = 0; int < array.length; int++) {

        }

    }

    function addRowFileter() {
        var item = new Object();
        item.codeName = $("#insdetailtype option:selected").text();
        item.name = $("#insdetailBrand option:selected").text();
        item.typeid = $("#insdetailtype option:selected").val();
        item.brandid = $("#insdetailBrand option:selected").val();
        item.name1 = $("#insdetailmodel").val();
        item.assetDRem = $("#insdetailremark").val();
        if (detailvaliedcheck()) {
            AUIGrid.addRow(AddDetailGrid, item, "last");
            $("#regDetailWindow").hide();
        }
    }
    
    
    
       function addRowItem() {
           div="AI";
            var item = new Object();
            //$("#addassetid").val(AUIGrid.getCellValue(myGridID ,selectedItem[0],'assetid'));
            item.codeName = $("#additemtype option:selected").text();
            item.name = $("#additemBrand option:selected").text();
            item.typeid = $("#additemtype option:selected").val();
            item.brandid = $("#additemBrand option:selected").val();     
            item.name1 = $("#additemmodel").val();
            item.assetDRem = $("#addremark").val();
            item.name3 = $("#additemname").val();
            item.valu = $("#additemvalue").val();
            item.assetDItmRem = $("#additemremark").val();
            item.assetid = $("#addassetid").val();
            if (itemvaliedcheck(div)) {     
            AUIGrid.addRow(upitemGrid, item, "last");
            $("#regUpdateWindow").hide();      
            }
         //$("#AddItemForm")[0].reset();  
        }
       

    function cancelRowFileter() {
        $("#regDetailWindow").hide();
    }

    function detail_info_insert() {
        $("#savePopbtn").click();
    }

    function destory(gridNm) {
        AUIGrid.destroy(gridNm);
        popClear();
    }

    function popClear() {
        $("#detailForm")[0].reset();
    }

    function colShowHide(gridNm, fied, checked) {
        if (checked) {
            AUIGrid.showColumnByDataField(gridNm, fied);
        } else {
            AUIGrid.hideColumnByDataField(gridNm, fied);
        }
    }
    function removeRow(rowIndex, gridNm) {
        
        AUIGrid.removeRow(gridNm, rowIndex);
        AUIGrid.removeSoftRows(gridNm);
    }
     function UpremoveRow(rowIndex, gridNm) {
       var selectedItem = AUIGrid.getSelectedIndex(upitemGrid);
       var assetDId=  AUIGrid.getCellValue(upitemGrid ,selectedItem[0],'assetDId');
       var assetDItmId=  AUIGrid.getCellValue(upitemGrid ,selectedItem[0],'assetDItmId');
           if(assetDId != undefined || assetDItmId != undefined){
            AUIGrid.removeRow(gridNm, rowIndex);
            AUIGrid.removeSoftRows(gridNm);    
           }else{
               Common.alert("can not delete an existing registered item.");
           }
       }
    
   function removeItem(rowIndex, gridNm) {
       div="RI";
       var selectedItem = AUIGrid.getSelectedIndex(upitemGrid);
       $("#multyassetid").val(AUIGrid.getCellValue(upitemGrid ,selectedItem[0],'assetDId'));
       $("#itemassetdid").val(AUIGrid.getCellValue(upitemGrid ,selectedItem[0],'assetDItmId'));
       assetsaveAjax(div);
        
    }
    
  function updateItem(flag) {
    var addList = AUIGrid.getAddedRowItems(upitemGrid);
        // 수정된 행 아이템들(배열)
    var updateList = AUIGrid.getEditedRowColumnItems(upitemGrid); 

        if(addList.length ==0 && updateList.length ==0){
            Common.alert("There Are No Update Items.");
        }else{
   
             if(flag=="E"){
                div="EI";
            }
            assetsaveAjax(div);
        }

    }

       function fn_srvMembershipList(itemtype) {
            Common.ajaxSync("GET", "/logistics/assetmng/selectTypeList.do", { groupCode : itemtype},            
                    function(result) {

                srvMembershipList = new Array();
                        for (var i = 0; i < result.length; i++) {
                            var list = new Object();
                            list.codeId = result[i].codeId;
                            list.codeName = result[i].codeName;
                            
                            //list.memcd = result[i].memcd;
                           
                            srvMembershipList.push(list);
                        } 
                            
                    });
        }
       
       function fn_BrandList() {
                Common.ajaxSync("GET", "/logistics/assetmng/selectBrandList.do", '',            
                  function(result) {
                    upBramdList = new Array();
                            for (var i = 0; i < result.length; i++) {
                                var list = new Object();
                                list.codeId = result[i].codeId;
                                
                                //list.memcd = result[i].memcd;
                                list.codeName = result[i].codeName;
                                
                                upBramdList.push(list);
                            } 
                                
                        });
            }
       
    function searchAssetMoveTransacton(){
          var param = $('#masterForm').serializeJSON();
            var url = "/logistics/assetmng/assetCard.do";
            console.log(param);
                Common.ajax("POST" , url , param , function(data){
                    AUIGrid.setGridData(assetMoveTrnsGrid , data.dataList);
                    AUIGrid.resize(assetMoveTrnsGrid); 
                });
        
    }
    function saveTrns(){
          //$("#cardTypeId").val("TR");
           var param = $('#masterForm').serializeJSON();
            var url = "/logistics/assetmng/saveAssetCard.do";
            console.log(param);
                Common.ajax("POST" , url , param , function(data){
                    Common.alert("Asset has been transfered to selected branch/department.");
                    getAssetListAjax();  
                    $("#masterWindow").hide();
                });
        
    }
    function saveTrnsRe(){
          //$("#cardTypeId").val("RT");
          var param = $('#masterForm').serializeJSON();
          $.extend(param, {
              'trnsbranchid' : 42,
              'transdepartment' : 38
          });
            var url = "/logistics/assetmng/saveAssetCardReturn.do";
            console.log(param);
                Common.ajax("POST" , url , param , function(data){
                    Common.alert("Asset has been returned to IT Department Store.");
                    getAssetListAjax();  
                    $("#masterWindow").hide();
                });
        
    }
    function saveStatus(){
          var param = $('#masterForm').serializeJSON();
          $.extend(param, {
              'trnsbranchid' : 0,
              'transdepartment' : 0
          });
            var url = "/logistics/assetmng/saveAssetStatus.do";
            console.log(param);
                Common.ajax("POST" , url , param , function(data){
                    Common.alert("Asset new status successfully saved.");
                    getAssetListAjax();  
                    $("#masterWindow").hide();
                });
        
    }
    function saveTrnsBulk(){
          //$("#cardTypeIdBulk").val("TR");
           var param = $('#bulkForm').serializeJSON();
            var url = "/logistics/assetmng/saveAssetCardBulk.do";
            console.log(param);
                Common.ajax("POST" , url , param , function(data){
                    Common.alert("Asset(s) has been transfered to selected branch/department.");
                    getAssetListAjax();  
                    $("#asstMoveTrnsBulkDiv").hide();
                });
        
    }
    function searchAssetBulkList(branchId,deptId){
                var url = "/logistics/assetmng/assetBulkList.do";
                var param ={
                         'searchbranchid' : branchId,
                         'searchdeptid'    :deptId
                };
                console.log(param);
                    Common.ajax("POST" , url , param , function(data){
                         console.log(data.dataList);
                         AUIGrid.setGridData(assetMoveTrnsBulkGrid, data.dataList);      
                         //AUIGrid.resize(assetMoveTrnsBulkGrid);
                    });
        
    }
    

    
    
</script>
</head>
<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>Organization</li>
    <li>AssetMng</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Asset Management</h2>
<ul class="right_btns">
    <li><p class="btn_blue"><a id="search"><span class="search"></span>Search</a></p></li>
     <li><p class="btn_blue"><a id="clear"><span class="clear"></span>Clear</a></p></li>
</ul>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
<form id="searchForm" name="searchForm" method="post">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:140px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Asset ID</th>
    <td>
    <input type="text" id="searchassetid" name="searchassetid" title="Code" placeholder="" class="w100p numberAmt" />
    </td>
    <th scope="row">Status</th>
    <td>
    <select class="w100p" id="searchstatus" name="searchstatus">
    </select>
    </td>
    <th scope="row">Brand</th>
    <td>
    <input type="text" id="searchbrand" name="searchbrand" placeholder=""  class="w100p" />
    </td>
</tr>
<tr>
    <th scope="row">Category</th>
    <td>
    <select id="searchcategory" name="searchcategory"   title="" placeholder="" class="w100p" >
    </select>
    </td>
    <th scope="row">Type</th>
    <td>
    <select id="searchtype" name="searchtype"    placeholder="" class="w100p">
    </select>
    </td>
    <th scope="row">Color</th>
    <td>
    <select id="searchcolor" name="searchcolor" placeholder="" class="w100p" >
    </select>
    </td>
</tr>
<tr>
    <th scope="row">Model Name</th>
    <td>
    <input type="text" id="searchmodelname" name="searchmodelname" title="Code" placeholder="" class="w100p" />
    </td>
    <th scope="row">Purchase Date</th>
    <td>
    <div class="date_set w100p"><!-- date_set start -->
    <p><input id="searchpurchasedate1" name="searchpurchasedate1" type="text" title="" placeholder="DD/MM/YYYY" class="j_date" readonly /></p>
    <span>To</span>
    <p><input id="searchpurchasedate2" name="searchpurchasedate2"  type="text" title="" placeholder="DD/MM/YYYY" class="j_date" readonly  /></p>
    </div><!-- date_set end -->
    </td>
    <th scope="row">Ref No</th>
    <td>
     <input type="text"  id="searchrefno"  name="searchrefno" class="w100p" />
    </td>
</tr>
<tr>
    <th scope="row">Branch</th>
    <td>
    <select id="searchbranchid" name="searchbranchid" onchange="getComboRelays('searchdepartment' , this.value , '', '')" class="w100p" >
    </select>
    </td>
    <th scope="row">Department</th>
    <td>
    <select class="w100p" id="searchdepartment" name="searchdepartment"  >
    </select>
    </td>
    <th scope="row"></th>
    <td>
    <input type="text"  id=""  name="" class="w100p" readonly />
    </td>
</tr>
<tr>
    <th scope="row">Invoice No</th>
    <td>
    <input type="text" id="searchinvoiceno" name="searchinvoiceno" title="" placeholder="" class="w100p" />
    </td>
    <th scope="row">Dealer</th>
    <td>
    <select id="searchdealer" name="searchdealer" placeholder="" class="w100p" >
    </select>
    </td>
    <th scope="row"></th>
    <td>
    <input type="text" id=""  name="" class="w100p"  readonly />
    </td>
</tr>
<tr>
    <th scope="row">Serial No</th>
    <td>
    <input type="text" id="searchserialno" name="searchserialno" title="" placeholder="" class="w100p" />
    </td>
    <th scope="row">Warranty No</th>
    <td>
    <input type="text" id="searchwarrantyno" name="searchwarrantyno" placeholder="" class="w100p"/>
    </td>
    <th scope="row">IMEI No</th>
    <td>
    <input type="text" id="searchimeino"  name="searchimeino" placeholder="" class="w100p"/>
    </td>
</tr>
<tr>
    <th scope="row">Mac Address</th>
    <td>
    <input type="text" id="searchmacaddress" name="searchmacaddress" title="" placeholder="" class="w100p" />
    </td>
    <th scope="row">Creator</th>
    <td>
   <input type="text" id="searchcreator" name="searchcreator" placeholder=""  class="w100p">
    </select>
    </td>
    <th scope="row">Create Date</th>
    <td>
    <div class="date_set w100p"><!-- date_set start -->
    <p><input id="searchcreatedate1" name="searchcreatedate1" type="text" title="" placeholder="DD/MM/YYYY" class="j_date" readonly /></p>
    <span>To</span>
    <p><input id="searchcreatedate2" name="searchcreatedate2"  type="text" title="" placeholder="DD/MM/YYYY" class="j_date" readonly  /></p>
    </div><!-- date_set end -->
    </td>
</tr>
<!-- <tr>
    <th scope="row">Name</th>
    <td colspan="5">
    <input type="text" id="locdesc" name="locdesc" title="Name" placeholder="" class="w100p" />
    </td>
</tr> -->
</tbody>
</table><!-- table end -->

<aside class="link_btns_wrap"><!-- link_btns_wrap start -->
<p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
<dl class="link_list">
    <dt>Link</dt>
    <dd>
    <ul class="btns">
        <li><p class="link_btn"><a id="copyAssetOpen">Copy Asset</a></p></li>
        <li><p class="link_btn"><a id="transAssetOpen">Transfer Asset (Single)</a></p></li>
        <li><p class="link_btn"><a id="returnAssetOpen">Return Asset</a></p></li>
        <li><p class="link_btn"><a id="statusAssetOpen">Lost / Obsolete / Deactivate</a></p></li>
    </ul>
    <ul class="btns">
        <li><p class="link_btn type2"><a id="transBulkAssetOpen">Transfer Asset (Bulk)</a></p></li>
    </ul>
    <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
    </dd>
</dl>
</aside><!-- link_btns_wrap end -->

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<ul class="right_btns">

<%--     <li><p class="btn_grid"><a href="#"><spring:message code='sys.btn.excel.up' /></a></p></li> --%>
    <li><p class="btn_grid"><a id="currentAsset">Branch/Department Current Asset</a></p></li>
    <li><p class="btn_grid"><a href="download"><spring:message code='sys.btn.excel.dw' /></a></p></li>
    <!-- <li><p class="btn_grid"><a id="exportTo">Export Search List</a></p></li> -->
    <li><p class="btn_grid"><a id="delete"><spring:message code='sys.btn.del' /></a></p></li>
    <%-- <li><p class="btn_grid"><a href="#"><spring:message code='sys.btn.ins' /></a></p></li> --%>
    <li><p class="btn_grid"><a id="update"><spring:message code='sys.btn.update' /></a></p></li>
    <li><p class="btn_grid"><a id="insert"><spring:message code='sys.btn.add' /></a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="grid_wrap" style="height:450px"></div>
</article><!-- grid_wrap end -->

<!-- <article id="detailView"> -->
<div class="divine_auto"><!-- divine_auto start -->

</div><!-- divine_auto end -->

</section><!-- search_result end -->

<div class="popup_wrap" id="masterWindow" style="display:none"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1 id="detailHead"></h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a id="masterClose">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->
<section class="pop_body"><!-- pop_body start -->
<h3 id="transH3_01" style="display: none;">Asset Informaton</h3>
<section class="tap_wrap"><!-- tap_wrap start -->
            <ul class="tap_type1">
                <li id="Master_info" class="on"><a href="#" id="trigger"> Master info </a></li>
                <li id="Details_info"><a href="#"> Details Info</a></li>
                <li id="Insert_info"><a href="#"> insert Info</a></li>
                <li id="Update_info"><a href="#"> update Info</a></li>
            </ul>

<article class="tap_area" >

<ul class="right_btns"  id="ViewTrnsBtn">
    <li><p class="btn_blue"><a id="ViewMoveTrns">View Movement Transaction</a></p></li>
</ul>
<form id="masterForm" name="masterForm" method="POST">
<table class="type1"><!-- table start -->
<caption>search table</caption>
<colgroup>
    <col style="width:120px" />
    <col style="width:*" />
    <col style="width:120px" />
    <col style="width:*" />
</colgroup>
<tbody>
<input type="hidden" id="masterassetid" name="masterassetid"/>
<input type="hidden" id="cardTypeId" name="cardTypeId"/>
<tr id="trinserthide1"> 
    <th scope="row">Assert Status</th>
    <td colspan="2" id="tdassertstatus"><input type="text" title="" placeholder=""  class="w100p" id="masterstatus" name="assetstatus"/></td>
    <th scope="row">Branch (Belong To)</th>
    <td colspan="2" id="tdbreanch"><input type="text" title="" placeholder=""  class="w100p" id="masterbreanch" name="masterbreanch"/></td>  
</tr>
<tr id="trinserthide2">
    <th scope="row">Department (Belong To)</th>
    <td colspan="2" id="tddepartment"><input type="text" title="" placeholder=""  class="w100p" id="masterdepartment" name="masterdepartment"/></td>
    <th scope="row">User (Belong To)</th>
    <td colspan="2" id="tduser"><input type="text" title="" placeholder=""  class="w100p" id="masteruser" name="masteruser"/></td>     
</tr>
<tr>
    <th scope="row">Category</th>
    <td colspan="2" id="tdcategory">
    <select id="mastercategory" name="mastercategory"  onchange="getComboRelayss('mastertype' , this.value , '', '')"  title="" placeholder=""  class="w100p">
    </select>  
    </td>
    <th scope="row">Type</th>
    <td colspan="2" id="tdtype">
    <select id="mastertype" name="mastertype" onchange="getComboRelayss('insdetailtype' , this.value , 'detailtype', '')" title="" placeholder=""  class="w100p" disabled=true>
    </select>
    </td>     
</tr>
<tr>
    <th scope="row">Model Name</th>
    <td colspan="2" id="tdmodelname"><input type="text" title="" placeholder=""  class="w100p" id="mastermodelname" name="mastermodelname"/></td>
    <th scope="row">Color</th>
    <td colspan="2" id="tdcolor">
    <select id="mastercolor" name="mastercolor" title="" placeholder=""  class="w100p">
    </select>
    </td>     
</tr>
<tr>
    <th scope="row">Invoice No</th>
    <td colspan="2" id="tdinvoiceno"><input type="text" title="" placeholder=""  class="w100p" id="masterinvoiceno" name="masterinvoiceno"/></td>
    <th scope="row">Dealer</th>
    <td colspan="2" id="tddealer">
    <select id="masterdealer" name="masterdealer" title="" placeholder=""  class="w100p">
    </select>
    </td>     
</tr>
<tr>
    <th scope="row">Purchase Date</th>
    <td colspan="2" id="tdpurchase date">
    <input id="masterpurchasedate" name="masterpurchasedate" type="text" title="" placeholder="DD/MM/YYYY" class="j_date" readonly />
    </td>
    <th scope="row">Brand</th>
    <td colspan="2" id="tdbrand">
     <select id="masterbrand" name="masterbrand" title="" placeholder=""  class="w100p">
    </select>
    </td>     
</tr>
<tr>
    <th scope="row">Purchase Amount</th>
    <td colspan="2" id="tdpurchaseamount"><input type="text" title="" placeholder=""  class="w100p numberAmt" id="masterpurchaseamount" name="masterpurchaseamount"/></td>
    <th scope="row">Ref No</th>
    <td colspan="2" id="tdrefno"><input type="text"  title="" placeholder=""  class="w100p" id="masterrefno" name="masterrefno"/></td>     
</tr>
<tr>
    <th scope="row">Serial No</th>
    <td colspan="2" id="tdserial no"><input type="text" title="" placeholder=""  class="w100p" id="masterserialno" name="masterserialno"/></td>
    <th scope="row">Warranty No</th>
    <td colspan="2" id="tdwarrantyno"><input type="text" title="" placeholder=""  class="w100p" id="masterwarrantyno" name="masterwarrantyno"/></td>     
</tr>
<tr>
    <th scope="row">Mac Address</th>
    <td colspan="2" id="tdmacaddress"><input type="text" title="" placeholder=""  class="w100p" id="mastermacaddress" name="mastermacaddress"/></td>
    <th scope="row">IMEI No</th>
    <td colspan="2" id="tdimei no"><input type="text" title="" placeholder=""  class="w100p" id="masterimeino" name="masterimeino"/></td>     
</tr>
<tr>
    <th scope="row">Remark</th>
    <td colspan="5" id="tdremark"><input type="text" title="" placeholder=""  class="w100p" id="masterremark" name="masterremark"/></td>    
</tr>
<!-- <tr>
<th scope="row">Detail Type</th>
  <td colspan="2" id="tdbrand">
     <select id="masterdetailtype" name="masterdetailtype" title="" placeholder=""  class="w100p" disabled=true>
    </select>
    </td>  
</tr> -->
</tbody>
</table><!-- table end -->

<aside class="title_line" id="a1"><!-- title_line start -->
<h2>Copy/Duplicate Informaton</h2>
</aside><!-- title_line end -->
    <table class="type1" id="CopyAssetInfo">
        <colgroup>
        <col style="width:300px" />
        <col style="width:*" />
        <col style="width:120px" />
        <col style="width:*" /> 
        </colgroup>
        <tbody>
        <tr>
            <th scope="row">Copy/Duplicate Quantity</th>
            <td><input type="number" title="" placeholder=""  class="w100p" id="copyquantity" name="copyquantity"/>
            </td>
            <td><input type="button" value="Copy Asset" id="copybtn" name="copybtn"/> 
            </td>
            <td></td>
        </tr>
        </tbody>
    </table>
    <table class="type1" id="trnasInfo">
        <colgroup>
        <col style="width:120px" />
        <col style="width:*" />
        <col style="width:120px" />
        <col style="width:*" /> 
        </colgroup>
        <tbody>
        <tr>
            <td scope="row" colspan="4"><h3>Transfer Informaton</h3></th>
        </tr>
        <tr>
            <th scope="row">Branch</th>
            <td colspan="3">
                 <select id="trnsbranchid" name="trnsbranchid" onchange="getComboRelayTrns('transdepartment' , this.value , '', '')" class="w100p" >
                 </select>
            </td>
        </tr>
        <tr>
            <th scope="row">Current Department</th>
            <td colspan="3"> 
                <select class="w100p" id="transdepartment" name="transdepartment" >
                </select>
            </td>
        </tr>
    </table>
    <table class="type1" id="statusInfo">
        <colgroup>
        <col style="width:120px" />
        <col style="width:*" />
        <col style="width:120px" />
        <col style="width:*" /> 
        </colgroup>
        <tbody>
        <tr>
            <th scope="row">Status</th>
            <td colspan="3">
                 <select id="status" name="status"  class="w100p" >
                  <option value=""></option>
                  <option value="7">Obsolete</option>
                  <option value="67">Lost</option>
                  <option value="8">Deactivate</option>
                </select>
            </td>
        </tr>
        <tr>
            <th scope="row">Remark</th>
            <td colspan="3"> 
               <input type="text" title="" placeholder=""  class="w100p" id="statusremark" name="statusremark"/></td>    
        </tr>
    </table>
<ul class="center_btns">
    <li><p class="btn_blue2 big"><a id="returnTrnsBtn">Confirm Return</a></p></li>
    <li><p class="btn_blue2 big"><a id="savePopbtn">SAVE</a></p></li>
    <li><p class="btn_blue2 big"><a id="saveTrnsBtn">SAVE</a></p></li>
    <li><p class="btn_blue2 big"><a id="saveStatusBtn">SAVE</a></p></li>
    <li><p class="btn_blue2 big"><a id="updatePopbtn">UPDATE</a></p></li>
    <li><p class="btn_blue2 big"><a id="cancelPopbtn" onclick="javascript:fn_assetDetailCancel();">CANCEL</a></p></li>
</ul>
</form>
</article>


<article class="tap_area" id="DtatilGrid_div_tap"  style="display:none;">
<div id="DtatilGrid_div" style="width:100%;"></div>             

<aside class="title_line" id="a2"><!-- title_line start -->
<h2>Copy/Duplicate Informaton</h2>
</aside><!-- title_line end -->
    <table class="type1" id="CopyAssetInfo2">
        <colgroup>
        <col style="width:300px" />
        <col style="width:*" />
        <col style="width:120px" />
        <col style="width:*" /> 
        </colgroup>
        <tbody>
        <tr>
            <th scope="row">Copy/Duplicate Quantity</th>
            <td><input type="number" title="" placeholder=""  class="w100p" id="copyquantity2" name="copyquantity"/>
            </td>
            <td><input type="button" value="Copy Asset" id="copybtn2" name="copybtn"/> 
            </td>
            <td></td>
        </tr>
        </tbody>
    </table>
</article>    
<article class="tap_area" id ="add_info_div" style="display:none;">
<!-- <div id="add_info_div" style="display:none;"> -->
<div>
                <aside class="title_line"><!-- title_line start -->
                    <h3 >Add Dtails Info</h3>
                    <ul class="left_opt">
                    <li><p class="btn_blue"><a id="detail_info_add">ADD</a></p></li>
                    </ul>
                </aside>
                <div id="addDetail_grid" style="width:100%;">
                </div>
                <ul class="left_opt">
                    <li><p class="btn_blue"><a onclick="javascript:detail_info_insert();">SAVE</a></p></li>
                </ul>         
 </div>  
</article>

<article class="tap_area" id ="Updadte_div_tap" style="display:none;">
<div>
                <aside class="title_line"><!-- title_line start -->
                    <h3 >Update Dtails Info</h3>
                    <ul class="left_opt">
                    <li><p class="btn_blue"><a id="item_info_add">ADD Item</a></p></li>
                    </ul>
                    <!-- <li><p class="btn_blue"><a id="multi_item_add">ADD Item info</a></p></li> -->
                </aside>
                <div id="UpDetail_div" style="width:100%;">
                </div>
                <ul class="left_opt">
                    <!-- <li id="addItm"><p class="btn_blue"><a onclick="javascript:updateItem('M')">SAVE</a></p></li> -->
                    <li id="upItm"><p class="btn_blue"><a onclick="javascript:updateItem('E')">UPDATE</a></p></li>
                </ul>         
 </div>  
</article>

</section><!--  tab -->


<div class="popup_wrap" id="regDetailWindow" style="display:none"><!-- popup_wrap start -->
    <header class="pop_header"><!-- pop_header start -->
        <h1>Add Details Info</h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a id="regDetailclose">CLOSE</a></p></li>
        </ul>
    </header><!-- pop_header end -->
<section class="pop_body"><!-- pop_body start -->  
            <!-- pop_body start -->
                <form id="detailForm" name="detailForm" method="POST">
                    <table class="type1">
                        <!-- table start -->
                        <caption>search table</caption>
                        <colgroup>
                            <col style="width: 150px" />
                            <col style="width: *" />
                            <col style="width: 160px" />
                            <col style="width: *" />
                        </colgroup>
                        <tbody>
                            <tr>
                                <th scope="row">Detail Type</th>
                                <td colspan="2">
                                <select id="insdetailtype" name="insdetailtype"   placeholder=""  class="w100p" disabled=true></select>
                                </td>
                                <th scope="row">Brand</th>
                                <td colspan="2">
                                <select id="insdetailBrand" name="insdetailBrand"  placeholder=""  class="w100p"></select>
                                </td>
                            </tr>
                            <tr>
                                <th scope="row">Model Name</th>
                                <td colspan="3">
                                <input type="text" id="insdetailmodel" name="insdetailmodel" class="w100p" />
                                </td>
                            </tr>
                            <tr>
                                <th scope="row">Remark</th>
                                <td colspan="5"><input type="text" id="insdetailremark" name="insdetailremark"  class="w100p" /></td>
                            </tr>
                        </tbody>
                    </table>
                    <!-- table end -->
                    <ul class="center_btns">
                        <li><p class="btn_blue2 big"><a onclick="javascript:addRowFileter();">SAVE</a></p></li> 
                        <li><p class="btn_blue2 big"><a onclick="javascript:cancelRowFileter();">CANCEL</a></p></li>
                    </ul>
                </form> 
    </section>  
</div>


<div class="popup_wrap" id="regUpdateWindow" style="display:none"><!-- popup_wrap start -->
    <header class="pop_header"><!-- pop_header start -->
        <h1>Add Equipment Info</h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#" id="regUpdateClose">CLOSE</a></p></li>
        </ul>
    </header><!-- pop_header end -->
<section class="pop_body"><!-- pop_body start -->  
            <!-- pop_body start -->
                <form id="AddItemForm" name="AddItemForm" method="POST">
                    <table class="type1">
                        <!-- table start -->
                        <caption>search table</caption>
                        <colgroup>
                            <col style="width: 150px" />
                            <col style="width: *" />
                            <col style="width: 160px" />
                            <col style="width: *" />
                        </colgroup>
                        <tbody>
                        <input type="hidden" id="addassetid" name="addassetid"/>
                            <tr>
                                <th scope="row">Detail Type</th>
                                <td colspan="2">
                                <select id="additemtype" name="additemtype" onchange=""   placeholder=""  class="w100p" ></select>
                                </td>
                                <th scope="row">Brand</th>
                                <td colspan="2">
                                <select id="additemBrand" name="additemBrand" onchange=""  placeholder=""  class="w100p"></select>
                                </td>
                            </tr>
                            <tr>
                                <th scope="row">Model Name</th>
                                <td colspan="3">
                                <input type="text" id="additemmodel" name="additemmodel" class="w100p" />
                                </td>
                            </tr>
                            <tr>
                                <th scope="row">Remark</th>
                                <td colspan="5"><input type="text" id="addremark" name="addremark"  class="w100p" /></td>
                            </tr>        
                            <tr>
                                <th scope="row">Item Name</th>
                                <td colspan="5"><input type="text" id="additemname" name="additemname"  class="w100p" /></td>
                            </tr>
                            <tr>
                                <th scope="row">Item Value</th>
                                <td colspan="5"><input type="text" id="additemvalue" name="additemvalue"  class="w100p" /></td>
                            </tr>
                            <tr>
                                <th scope="row">Item Remark</th>
                                <td colspan="5"><input type="text" id="additemremark" name="additemremark"  class="w100p" /></td>
                            </tr>
                        </tbody>
                    </table>
                    <!-- table end -->
              
                    <ul class="center_btns">
                        <li><p class="btn_blue2 big"><a onclick="javascript:addRowItem();">SAVE</a></p></li> 
                        <li><p class="btn_blue2 big"><a onclick="javascript:cancelRowFileter();">CANCEL</a></p></li>
                    </ul>
                </form> 
    </section>  
</div>



<div class="popup_wrap" id="asstMoveTrnsDiv" style="display:none"><!-- popup_wrap start -->
    <header class="pop_header"><!-- pop_header start -->
        <h1>Asset Movement Transaction</h1>
                <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
        </ul>
    </header><!-- pop_header end -->
    
<section class="pop_body"><!-- pop_body start -->  
                <div id="assetMoveTrnsGrid" style="width:100%;">
                </div>
    </section>  
</div>

</section>
</div>

<div class="size_big popup_wrap" id="asstMoveTrnsBulkDiv" style="display:none"><!-- popup_wrap start -->
    <header class="pop_header"><!-- pop_header start -->
        <h1>Bulk Transfer Asset</h1>
                <ul class="right_opt">
                    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
                </ul>
    </header><!-- pop_header end -->
    
<section class="pop_body"><!-- pop_body start --> 
 <form id="bulkForm" name="bulkForm" method="POST">
 <input type="hidden" id="masterassetidBulk" name="masterassetidBulk"/>
<input type="hidden" id="cardTypeIdBulk" name="cardTypeIdBulk"/>
                    <table class="type1">
                        <!-- table start -->
                        <caption>search table</caption>
                        <colgroup>
                            <col style="width: 150px" />
                            <col style="width: *" />
                            <col style="width: 160px" />
                            <col style="width: *" />
                        </colgroup>
                        <tbody>
                             <tr>
                                <td scope="row" colspan="4"><h3>Transfer Informaton</h3></th>
                            </tr>
                            <tr>
                                <th scope="row"  rowspan="2">Transfer From</th>
                                <td colspan="3">
                                     <select id="trnsbranchidFrom" name="trnsbranchidFrom" onchange="getComboRelayTrns('transdepartmentFrom' , this.value , '', '')" class="w100p" >
                                     </select>
                                </td>
                            </tr>
                            <tr>
                               <!--  <th scope="row">Current Department</th> -->
                                <td colspan="3"> 
                                    <select class="w100p" id="transdepartmentFrom" name="transdepartmentFrom"  onchange="getComboRelayTrnsBulk('' , this.value , '', '')" >
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <th scope="row"  rowspan="2">Transfer To</th>
                                <td colspan="3">
                                     <select id="trnsbranchidTo" name="trnsbranchidTo" onchange="getComboRelayTrns('transdepartmentTo' , this.value , '', '')" class="w100p" >
                                     </select>
                                </td>
                            </tr>
                            <tr>
                               <!--  <th scope="row">Current Department</th> -->
                                <td colspan="3"> 
                                    <select class="w100p" id="transdepartmentTo" name="transdepartmentTo"  >
                                    </select>
                                </td>
                            </tr>
                            <tr>
                               <td colspan="4"><h3>Asset To Transfer</h3></td>
                            </tr>
                           </tbody>
                    </table>
                    <article class="grid_wrap"><!-- grid_wrap start -->
                        <div id="assetMoveTrnsBulkGrid"></div>
                    </article><!-- grid_wrap end -->
                    
                    <!-- table end -->
                    <ul class="center_btns">
                        <li><p class="btn_blue2 big"><a id="transAsset">Transfer Asset</a></p></li>
                    </ul>
                </form> 
    </section>  
</div>
<form name="reportPDFForm" id="reportPDFForm"  method="post">
    <input type="hidden" id="reportFileName" name="reportFileName" value="" />    
    <input type="hidden" id="viewType" name="viewType" value="PDF" /> 
</form>
</section>


