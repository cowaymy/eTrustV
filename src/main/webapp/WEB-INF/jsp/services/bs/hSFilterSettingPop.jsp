<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript" language="javascript">

	var myDetailGridIDInActive;
    var myDetailGridIDActive;
    


    function createAUIGridInactive(){
        // AUIGrid 칼럼 설정
        var columnLayout = [ 
                {
                    dataField : "",
                    headerText : "",
                    width : 130,
                    renderer : {
                          type : "ButtonRenderer",
                          labelText : "View",
                          onclick : function(rowIndex, columnIndex, value, item) {

                               if($("#orderId").val() == "" || $("#orderId").val() == undefined) {
                                    return false;
                               }
                              
                              //Common.popupDiv("/services/bs/hsBasicInfoPop.do?MOD=EDIT", $("#popEditForm").serializeJSON(), null , true , '');
                              Common.popupDiv("/services/bs/hSFilterUseHistoryPop.do", $("#orderInfoForm").serializeJSON(), null , true , '');
                            }
			         }
                },{        

				    dataField : "",
				    headerText : "",
				    width : 80,
				    renderer : {
				        type : "IconRenderer",
				        iconPosition : "aisleRight",  // 아이콘 위치 
				        iconTableRef :  { // icon 값 참조할 테이블 레퍼런스
				            "default" : "${pageContext.request.contextPath}/resources/images/common/btn_plus.gif" // default
				        },
				        onclick : function(rowIndex, columnIndex, value, item) {
				                                        var SendItem = new Object();
                            SendItem.srvFilterId = item.srvFilterStkId;
                            SendItem.stkCode    = item.stkCode;
                            SendItem.stkDesc    = item.stkDesc;
                            SendItem.c4           = "";
                            SendItem.srvFilterPriod = "";
                            SendItem.srvFilterPrvChgDt = "";
                            
                            AUIGrid.addRow(myDetailGridIDActive, SendItem, 'last');  
                            
                            Common.ajax("POST", "/services/bs/doSaveFilterUpdate.do", {SRV_FILTER_ID : item.srvFilterId}, function(result) {   
                                console.log(result);
                                
                                if(result.code = "00"){
                                    $("#popClose").click();
                                   fn_getInActivefilterInfo();
                                   fn_getActivefilterInfo();
                                     Common.alert("<b>Filter info successfully updated.</b>",fn_close);
                               }else{
                                    Common.alert("<b>Failed to update filter info. Please try again later.</b>");  
                               } 
                            });    
                        }
                    }
                },{
                    dataField:"stkCode",
                    headerText:"Filter Code",
                    width:140,
                    height:30
                }, {                        
                    dataField : "srvFilterId",
                    headerText : "Filter id",
                    width : 240,                             
                    visible:false 
                }, {                        
                    dataField : "stkDesc",
                    headerText : "Filter Name",
                    width : 240      
               }, {                        
                    dataField : "srvFilterPrvChgDt",
                    headerText : "Last Change",
                    width : 240 ,
                    dataType : "date",
                    formatString : "dd/mm/yyyy"       
              }, {                        
                    dataField : "c3",
                    headerText : "Update By",
                    width : 240         
              }, {                        
                    dataField : "c2",
                    headerText : "Update At",
                    width : 240,
                    dataType : "date",
                    formatString : "dd/mm/yyyy"  
            }];
            // 그리드 속성 설정
            var gridPros = {
                // 페이징 사용       
                //usePaging : true,
                // 한 화면에 출력되는 행 개수 20(기본값:20)
                //pageRowCount : 20,
                
                editable : false,
                
                //showStateColumn : true, 
                
                //displayTreeOpen : true,
                
                headerHeight : 30,
                
                // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
                skipReadonlyColumns : true,
                
                // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
                wrapSelectionMove : true,
                
                // 줄번호 칼럼 렌더러 출력
                showRowNumColumn : true
        
            };
                //myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout, gridPros);
                myDetailGridIDInActive = AUIGrid.create("#grid_wrap_Inactive", columnLayout, gridPros);
    }
    
    
    
    
    
        function createAUIGridActive(){
        // AUIGrid 칼럼 설정
        var columnLayout = [ {
                    dataField : "",
                    headerText : "",
                    width : 170,
                    renderer : {
                          type : "ButtonRenderer",
                          labelText : "View",
                          onclick : function(rowIndex, columnIndex, value, item) {
                               
                               if($("#orderId").val() == "" || $("#orderId").val() == undefined) {
                                    return false;
                               }
                              
                              //Common.popupDiv("/services/bs/hsBasicInfoPop.do?MOD=EDIT", $("#popEditForm").serializeJSON(), null , true , '');
                              Common.popupDiv("/services/bs/hSFilterUseHistoryPop.do", $("#orderInfoForm").serializeJSON(), null , true , '');
                            }
                     }
                },{      
                    dataField:"srvFilterId",
                    headerText:"srvFilterId",
                    width:110,
                    height:30,          
                    visible:false
                }, {                        
                    dataField:"stkCode",
                    headerText:"Filter Code",
                    width:110,
                    height:30,          
                    editable : false
                }, {                        
                    dataField : "stkId",
                    headerText : "Filter id",
                    width : 240,                             
                    visible:false,          
                    editable : false 
                }, {                        
                    dataField : "stkDesc",
                    headerText : "Filter Name",
                    width : 240,          
                    editable : false
                }, {                        
                    dataField : "c4",
                    headerText : "Type",
                    width : 100,          
                    editable : false
                }, {                        
                    dataField : "srvFilterPriod",
                    headerText : "Change Period",
                    width : 120,          
                    editable : false                    
		         }, {                                  
                    dataField : "srvFilterPrvChgDt",
                    headerText : "Last Change",
                    width : 180,
                    dataType : "date",
                    formatString : "dd/mm/yyyy" ,
				    editRenderer : {
				        type : "CalendarRenderer",
				        openDirectly : true, // 에디팅 진입 시 바로 달력 열기
				        onlyCalendar : true, // 사용자 입력 불가, 즉 달력으로만 날짜입력 (기본값 : true)
				        showExtraDays : true // 지난 달, 다음 달 여분의 날짜(days) 출력
				    }            
                }, {                      
                    dataField : "c2",
                    headerText : "CreateAt",
                    width : 180,
                    dataType : "date",
                    formatString : "dd/mm/yyyy",          
                    editable : false                     
                }, {                        
                    dataField : "c3",
                    headerText : "CreateBy",
                    width : 180,          
                    editable : false                                                                      
	                },{                        
	                dataField : "srvFilterLastSerial",
	                headerText : "Last Serial",
	                width : 180,          
                    editable : false                                                                                 
	                },{                        
		            dataField : "srvFilterPrevSerial",
		            headerText : "Prev Serial",
		            width : 180,          
                    editable : false         
                     },{
                        dataField : "undefined",
                        headerText : "",
                        width : 170,
                        renderer : {
                              type : "ButtonRenderer",
                              labelText : "Deactivate",
                              onclick : function(rowIndex, columnIndex, value, item) {
                              
                                 var SRV_FILTER_ID =    AUIGrid.getCellValue(myDetailGridIDActive, rowIndex, "srvFilterId");
                                 fn_clicConfirm(SRV_FILTER_ID);
                                 
                              }
                       }
                     },{
                        dataField : "undefined",
                        headerText : "",
                        width : 170,
                        renderer : {
                              type : "ButtonRenderer",
                              labelText : "Update",
                              onclick : function(rowIndex, columnIndex, value, item) {

                                  /* var dtFrom = Number(item.srvFilterPrvChgDt.toString().replace(/\//g,"")); */

                                  var SRV_FILTER_ID =    AUIGrid.getCellValue(myDetailGridIDActive, rowIndex, "srvFilterId");
                                   var SRV_FILTER_UPD_DT =  AUIGrid.getCellValue(myDetailGridIDActive, rowIndex, "srvFilterPrvChgDt").replace(/\//g,"");
						           
						           var srvFilterUpdateForm = {
						             "SRV_FILTER_ID" : SRV_FILTER_ID,
						             "SRV_FILTER_UPD_DT" : SRV_FILTER_UPD_DT
						            }
            
						            Common.ajax("POST", "/services/bs/doSaveFilterUpdate.do", srvFilterUpdateForm, function(result) {   
						                 console.log(result);
						                 
						                 if(result.code = "00"){
						                     $("#popClose").click();
						                    fn_getInActivefilterInfo();
						                    fn_getActivefilterInfo();
						                      Common.alert("<b>Filter info successfully updated.</b>",fn_close);
						                }else{
						                     Common.alert("<b>Failed to update filter info. Please try again later.</b>");  
						                } 
						             });
                                  
                                  }
                           }    		            
	              }
                ];
            // 그리드 속성 설정
            var gridPros = {
                // 페이징 사용       
                //usePaging : true,
                // 한 화면에 출력되는 행 개수 20(기본값:20)
                //pageRowCount : 20,
                
                editable : true,
                
                //showStateColumn : true, 
                
                //displayTreeOpen : true,
                
                headerHeight : 30,
                
                // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
                skipReadonlyColumns : true,
                
                // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
                wrapSelectionMove : true,
                
                // 줄번호 칼럼 렌더러 출력
                showRowNumColumn : true
        
            };
                //myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout, gridPros);
                myDetailGridIDActive = AUIGrid.create("#grid_wrap_active", columnLayout, gridPros);
    }
    
    
    
       function fn_clicConfirm(SRV_FILTER_ID){

            
            $("#orderInfoForm #SRV_FILTER_ID").val(SRV_FILTER_ID);
                        
            Common.confirm("<spring:message code='sys.common.alert.save'/>",fn_clickDeactivate);
       }
       
    
	   function fn_clickDeactivate(){
	   
	          if($("#SRV_FILTER_ID").val() == "" || $("#SRV_FILTER_ID").val() == undefined) {
	              return false;
	          }
	         
	        
	          
	        var srvFilterForm = {
	         "SRV_FILTER_ID" : $("#SRV_FILTER_ID").val()
	        }
	        
	        Common.ajax("POST", "/services/bs/doSaveDeactivateFilter.do", srvFilterForm, function(result) {   
	             console.log(result);
	             
	             if(result.code = "00"){
	                 $("#popClose").click();
                    fn_getInActivefilterInfo();
                    fn_getActivefilterInfo();
	                  Common.alert("<b>The filter successfully deactivate.</b>",fn_close);
	            }else{
	                 Common.alert("<b>Failed to deactivate this filter. Please try again later.</b>");  
	            } 
	         });
	
	
       	}      




    
		function fn_getActivefilterInfo(){
		    
		    Common.ajax("GET", "/services/bs/getActivefilterInfo.do", {salesOrdId : '${hSOrderView.ordId}'}, function(result) {
		        console.log("getActivefilterInfo.");
		        console.log( result);
		        AUIGrid.setGridData(myDetailGridIDActive, result);         //getActivefilterInfo
		    });
		    
		}
		
		
		function fn_getInActivefilterInfo(){
		    
		    Common.ajax("GET", "/services/bs/getInActivefilterInfo.do", {salesOrdId : '${hSOrderView.ordId}'}, function(result) {
		        console.log("getInActivefilterInfo.");
		        console.log( result);
		        AUIGrid.setGridData(myDetailGridIDInActive, result);        
		    });
		    
		}
		
		
        
/*         function fn_getAddFilter(){
                Common.ajax("GET", "/services/bs/getAddFilterInfo.do", {salesOrdId : '${hSOrderView.ordId}'}, function(result) {
                Common.popupDiv("/services/bs/hSFilterSettingPop.do?&salesOrdId="+salesOrdId, null, null , true , '_FilterAddPop');
                
                console.log("getInActivefilterInfo.");
                console.log( result);
                AUIGrid.setGridData(myDetailGridIDInActive, result);        
            });
        
        } */
        
        
        
       function fn_getAddFilter() {
            Common.popupDiv("/services/bs/hSAddFilterSetPop.do?&salesOrdId=" + ${hSOrderView.ordId} +"&stkId="+ ${hSOrderView.stkId} , null, null , true , '_AddFilterPop');
       }
        
        
        
        
        
		$(document).ready(function() {
		    createAUIGridInactive();
		    createAUIGridActive();
		    
		    fn_getInActivefilterInfo();
		    fn_getActivefilterInfo();
		    
		});

		
		
    function fn_close() {
        $("#popClose").click();
    }		
		
		
		

</script>


<body>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>BS Management - Configuration - Filter Setting</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->
<form action="#" method="post"  id='orderInfoForm'  name='orderInfoForm' >
    <input type="hidden" name="SRV_FILTER_ID"  id="SRV_FILTER_ID" value=${srvFilterId}/>  
    <input type="hidden" name="orderId"  id="orderId" value="${hSOrderView.ordId}"/>
    <input type="hidden" name="stkId"  id="stkId" value="${hSOrderView.stkId}"/>  

  

<aside class="title_line"><!-- title_line start -->
<h2>Order Information</h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:165px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Order No</th>
    <td>
    <input type="text" title="" id="entry_orderNo" name="entry_orderNo"  value="${hSOrderView.ordNo}" placeholder="" class="readonly " readonly="readonly" style="width: 157px; " />
    </td>
    <th scope="row">Applicaton Type</th>
    <td>
    <input type="text" title="" id="entry_appType" name="entry_appType"  value="${hSOrderView.appTypeCode}" placeholder="" class="readonly " readonly="readonly" style="width: 157px; "/>
    </td>
    <th scope="row"> Order Status</th>
    <td>
    <input type="text" title="" id="entry_StusCode" name="entry_StusCode"  value="${hSOrderView.ordStusCode}" placeholder="" class="readonly " readonly="readonly" style="width: 157px; "/>
    </td>
</tr>
<tr>
    <th scope="row">Product Code</th>
    <td>
    <input type="text" title="" id="entry_product" name="entry_product"  value="${hSOrderView.stockCode}" placeholder="" class="readonly " readonly="readonly" style="width: 157px; "/>
    </td>
    <th scope="row">Product Name</th>
    <td colspan="3">
    <input type="text" title="" id="entry_stockDesc" name="entry_stockDesc"  value="${hSOrderView.stockDesc}" placeholder="" class="readonly " readonly="readonly" style="width: 306px; "/>
    <input  type='hidden' id='stkId' name='stkId'  value='${hSOrderView.stkId}'></textarea>
    </td>
</tr>
<tr>
    <th scope="row">Customer Name</th>
    <td colspan="3">
    <input type="text" title="" id="entry_custName" name="entry_custName"  value="${hSOrderView.custName}" placeholder="" class="readonly " readonly="readonly" style="width: 444px; "/>
    </td>
    <th scope="row">NRIC/Company No</th>
    <td>
    <input type="text" title="" id="entry_nric" name="entry_nric"  value="${hSOrderView.custNric}" placeholder="" class="readonly " readonly="readonly" style="width: 157px; "/>
    </td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2>Inactive Filter List</h2>
</aside><!-- title_line end -->

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="grid_wrap_Inactive" style="width: 100%; height: 134px; margin: 0 auto;"></div>
</article><!-- grid_wrap end -->

<aside class="title_line"><!-- title_line start -->
<h2>Filter Setting</h2>
<ul class="right_btns">
    <li><p class="btn_grid"><a href="javascript:fn_getAddFilter()"  id="addFilter">Add Filter</a></p></li>
</ul>
</aside><!-- title_line end -->

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="grid_wrap_active" style="width: 100%; height: 334px; margin: 0 auto;"></div>
</article><!-- grid_wrap end -->

</form>
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->

</body>