<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:r="http://ws.cmctos.com.my/ctosnet/response"
                version="1.0">
    
    <!-- start section b template -->	
    <xsl:template name="section_b_template">
        
        <xsl:if test="../r:summary/r:enq_sum[@ptype='C']">
        
            <p class="title">B: COMPANY PROFILE</p>
        
            <xsl:if test="r:section_a[@data = 'true']">
            
                <xsl:call-template name="section_b_CE_template"/>
                <xsl:call-template name="section_b_Cr_template"/>
                <xsl:call-template name="section_b1_su_subsidiaries_template"/>                    
            
            </xsl:if>
        
            <xsl:if test="r:section_a[@data = 'false']">            
            
                <p class="info">No Information Available</p>
            
                <br/>
            
            </xsl:if>

        </xsl:if>

        <!-- start b1: business profile -->
        <xsl:if test="../r:summary/r:enq_sum[@ptype='B'] or ../r:summary/r:enq_sum[@ptype='O']">
        
            <p class="title">
                B1: BUSINESS PROFILE
            </p>
        
            <xsl:if test="r:section_a[@data = 'true']">
            
                <xsl:call-template name="section_b1_subreport_template"/>
            
            </xsl:if>
        
            <xsl:if test="r:section_a[@data = 'false']">
            
                <p class="info">No Information Available</p>
            
                <br/>
            
            </xsl:if>
        
        </xsl:if>
        <!-- finish b1: business profile -->
    
        <!-- start b1: directorships and business interests -->
        <xsl:if test="../r:summary/r:enq_sum[@ptype='I']">
        
            <p class="title">
                B1: DIRECTORSHIPS AND BUSINESS INTERESTS
            </p>
        
            <xsl:if test="r:section_c[@data = 'true']">                
        
                <xsl:call-template name="section_b1_directorships_and_business_interests_template"/>
                <xsl:call-template name="section_b1_subreport_template"/>
    
            </xsl:if>
        
            <xsl:if test="r:section_c[@data = 'false']">
            
                <p class="info">No Information Available</p>
            
                <br/>
            
            </xsl:if>
        
        </xsl:if>
        <!-- finish b1: directorships and business interests -->

        <xsl:if test="../r:summary/r:enq_sum[@ptype != 'C']">
        
            <p class="title">
                B2: ADDRESS RECORDS
            </p>
        
            <xsl:if test="r:section_a[@data = 'true']">
				
                <xsl:call-template name="section_b2_subreport_template"/>
            
            </xsl:if>
        
            <xsl:if test="r:section_a[@data = 'false']">
            
                <p class="info">No Information Available</p>
            
                <br/>
            
            </xsl:if>
        
        </xsl:if>

    </xsl:template>
    <!-- finish section b template -->
    
    
    
    <xsl:template name="section_b_AIF_director">        
        <xsl:if test="r:directors/r:director">
            <p class="title">DIRECTORS</p>
            <table class="table">
                <tr>
                    <td width="16%" class="header">Name</td>
                    <td width="14%" class="header">Residential Address</td>
                    <td width="14%" class="header text-center">New ID No.</td>
                    <td width="14%" class="header text-center">Old IC No.</td>
                    <td width="14%" class="header text-center">Designation</td>
                    <td width="14%" class="header text-center">Date of Appointment</td>
                    <td width="14%" class="header text-center">Date of Resignation</td>
                </tr>
                <xsl:for-each select="r:directors/r:director">
                    <xsl:if test="r:position = 'DS' or r:position = 'DO' or r:position = 'AD'">
                        <tr>
                            <td>
                                <xsl:value-of select="r:name"/>
                            </td>
                            <td>
                                <xsl:call-template name="check_empty_string">
                                    <xsl:with-param name="value" select="r:addr"/>
                                </xsl:call-template>
                            </td>
                            <td class="text-center">
                                <xsl:call-template name="check_empty_string">
                                    <xsl:with-param name="value" select="r:nic_brno"/>
                                </xsl:call-template>
                            </td>
                            <td class="text-center">
                                <xsl:call-template name="check_empty_string">
                                    <xsl:with-param name="value" select="r:ic_lcno"/>
                                </xsl:call-template>
                            </td>
                            <td class="text-center">
                                <xsl:call-template name="check_empty_string">
                                    <xsl:with-param name="value" select="r:position"/>
                                </xsl:call-template>
                            </td>
                            <td class="text-center">
                                <xsl:call-template name="check_empty_string">
                                    <xsl:with-param name="value" select="r:appoint"/>
                                </xsl:call-template>
                            </td>
                            <td class="text-center">
                                <xsl:call-template name="check_empty_string">
                                    <xsl:with-param name="value" select="r:resign_date"/>
                                </xsl:call-template>
                            </td>                        
                        </tr>
                    </xsl:if>                
                </xsl:for-each>
            </table>
            <br/>          
        </xsl:if>        
    </xsl:template>
    
    <xsl:template name="section_b_AIF_shareholder">        
        <xsl:if test="r:directors/r:director">
            <p class="title">SHAREHOLDERS</p>
            <table class="table">
                <tr>
                    <td width="28%" class="header text-left">Name</td>
                    <td width="18%" class="header text-center">BR / New ID No.</td>
                    <td width="18%" class="header text-center">LC / Old IC No.</td>
                    <td width="18%" class="header text-center">Shareholding (Shares)</td>
                    <td width="18%" class="header text-center">Shareholding (%)</td>
                </tr>
                <xsl:for-each select="r:directors/r:director">
                    <xsl:if test="r:position = 'DS' or r:position = 'SO'">
                        <tr>
                            <td>
                                <xsl:call-template name="check_empty_string">
                                    <xsl:with-param name="value" select="r:name"/>
                                </xsl:call-template>
                            </td>
                            <td class="text-center">
                                <xsl:call-template name="check_empty_string">
                                    <xsl:with-param name="value" select="r:nic_brno"/>
                                </xsl:call-template>
                            </td>
                            <td class="text-center">
                                <xsl:call-template name="check_empty_string">
                                    <xsl:with-param name="value" select="r:ic_lcno"/>
                                </xsl:call-template>
                            </td>
                            <td class="text-right">
                                <xsl:call-template name="check_empty_number">
                                    <xsl:with-param name="number" select="r:equity"/>
                                </xsl:call-template>
                            </td>
                            <td class="text-right">
                                <xsl:call-template name="check_empty_number">
                                    <xsl:with-param name="number" select="r:equity_percentage"/>
                                </xsl:call-template>
                            </td>                                    
                        </tr>            	
                    </xsl:if>                
                </xsl:for-each>
            </table>   
            <br/>   
        </xsl:if>        
    </xsl:template>
    
    <!-- start section_b_CE -->
    <xsl:template name="section_b_CE_template">        
        <xsl:if test="r:section_a/r:record[@rpttype = 'CE']">            
            <xsl:for-each select="r:section_a/r:record[@rpttype = 'CE']">        
                <table class="table">
                    <tr>
                        <td class="title" colspan="2">
                            <xsl:value-of select="position()"/>. LAST UPDATED: 
                            <xsl:call-template name="check_empty_string">
                                <xsl:with-param name="value" select="r:cpo_date"/>
                            </xsl:call-template>
                        </td>
                    </tr>
                    <tr>
                        <th class="caption">Company Name</th>
                        <td class="long-content">
                            <xsl:call-template name="check_empty_string">
                                <xsl:with-param name="value" select="r:name"/>
                            </xsl:call-template>
                            <xsl:if test="r:ic_lcno != '' and r:lc_checksum != ''">
                                (<xsl:value-of select="r:ic_lcno"/>-<xsl:value-of select="r:lc_checksum"/>)
                            </xsl:if>
                            <xsl:if test="r:ic_lcno != '' and r:lc_checksum = ''">
                                (<xsl:value-of select="r:ic_lcno"/>)
                            </xsl:if>
                        </td>
                    </tr>
                    <tr>
                        <th class="caption">Registration Date</th>
                        <td class="long-content">
                            <xsl:call-template name="check_empty_string">
                                <xsl:with-param name="value" select="r:register_date"/>
                            </xsl:call-template>
                        </td>
                    </tr>
                    <tr>
                        <th class="caption">Registered Address</th>
                        <td class="long-content">
                            <xsl:call-template name="check_empty_string">
                                <xsl:with-param name="value" select="r:addr"/>
                            </xsl:call-template>
                        </td>
                    </tr>
                    <tr>
                        <th class="caption">Business Sector</th>
                        <td class="long-content">
                            <xsl:call-template name="check_empty_string">
                                <xsl:with-param name="value" select="r:type_of_business"/>
                            </xsl:call-template>
                        </td>
                    </tr>
                    <tr>
                        <th class="caption">Company Status</th>
                        <td class="long-content">
                            <xsl:call-template name="check_empty_string">
                                <xsl:with-param name="value" select="r:status"/>
                            </xsl:call-template>
                        </td>
                    </tr>
                    <tr>
                        <th class="caption">Auditor</th>
                        <td class="long-content">
                            <xsl:call-template name="check_empty_string">
                                <xsl:with-param name="value" select="r:accounts/@auditor_name"/>
                            </xsl:call-template>
                        </td>
                    </tr>
                    <tr>
                        <th class="caption">Financial Year End</th>
                        <td class="long-content">
                            <xsl:choose>
                                <xsl:when test="r:accounts/r:account[1]/r:pldd[text() != '']">
                                    <xsl:copy-of select = "translate(r:accounts/r:account[1]/r:pldd, '-', '/')" /> 
                                </xsl:when>
                                <xsl:otherwise>-</xsl:otherwise>
                            </xsl:choose>
                        </td>
                    </tr>
                    <tr>
                        <th class="caption">Remark</th>
                        <td class="long-content">
                            <xsl:call-template name="check_empty_string">
                                <xsl:with-param name="value" select="r:remark"/>
                            </xsl:call-template>
                        </td>
                    </tr>
                </table>
                    
                <br/>                                   
                   
                <table class="table">
                    <xsl:call-template name="section_b_CE_previous_names"/>
                </table>
                
                <br/>
                
                <table class="table">
                    <tr>
                        <td class="title" colspan="3">ADDRESS RECORDS</td>
                    </tr>
                    <tr>
                        <td width="75%" class="header">Address</td>
                        <td width="15%" class="header text-center">Last Updated</td>
                        <td width="10%" class="header tect-center">Source</td>
                    </tr>
		                    
                    <xsl:if test="r:section_a/r:record/r:addr or r:section_a/r:record/r:addr1 or r:ccris_addresses/r:ccris_address">
                        
                        <xsl:if test="r:addr">
                            
                            <tr>
                                <td>
                                    <xsl:call-template name="check_empty_string">
                                        <xsl:with-param name="value" select="r:addr"/>
                                    </xsl:call-template>		                    		
                                </td>
                                <td class="text-center">
                                    <xsl:call-template name="check_empty_string">
                                        <xsl:with-param name="value" select="r:cpo_date"/>
                                    </xsl:call-template>		                    		
                                </td>
                                <td class="text-center">
                                    SSM
                                </td>
                            </tr>
                            
                        </xsl:if>
		                    
                        <xsl:if test="r:addr1">
                            
                            <tr>
                                <td>
                                    <xsl:call-template name="check_empty_string">
                                        <xsl:with-param name="value" select="r:addr1"/>
                                    </xsl:call-template>		                    		
                                </td>
                                <td class="text-center">
                                    <xsl:call-template name="check_empty_string">
                                        <xsl:with-param name="value" select="r:cpo_date"/>
                                    </xsl:call-template>		                    		
                                </td>
                                <td class="text-center">
                                    SSM
                                </td>
                            </tr>
                            
                        </xsl:if>
		                    
                        <xsl:call-template name="section_b_CE_address_records_ccris_template"/>
                        
                    </xsl:if>
                    
                    <xsl:if test="not(r:section_a/r:record/r:addr) and not(r:section_a/r:record/r:addr1) and not(r:ccris_addresses/r:ccris_address)">
                        
                        <tr>
                            <td colspan="3">
                                No Information Available
                            </td>
                        </tr>
                        
                    </xsl:if>
                </table>
                    
                <br/>
                
                <table class="table">
                    <tr>
                        <td class="title" colspan="5">SHARE CAPITAL</td>
                    </tr>
                    <tr>
                        <th class="caption">Authorised Capital</th>
                        <td>
                            <xsl:call-template name="check_empty_number">
                                <xsl:with-param name="number" select="r:capital_details/r:auth_capital"/>
                            </xsl:call-template>
                        </td>
                        <th class="caption">Paid-up Capital</th>
                        <td colspan="2">
                            <xsl:call-template name="check_empty_number">
                                <xsl:with-param name="number" select="r:capital_details/r:paidup_capital"/>
                            </xsl:call-template>
                        </td>
                    </tr>
                    <tr>
                        <td class="caption bold">Type</td>
                        <td class="caption text-center bold">Number of Shares</td>
                        <td class="caption text-center bold">Nominal Value (SEN)</td>
                        <td class="caption text-center bold">Other than Cash</td>
                        <td class="caption text-center bold">Total Issue Capital</td>
                    </tr>
                    <tr>
                        <th class="caption">Ordinary</th>
                        <td class="text-right">
                            <xsl:call-template name="check_empty_number">
                                <xsl:with-param name="number" select="r:capital_details/r:paidup_ord_amount"/>
                            </xsl:call-template>
                        </td>
                        <td class="text-right">
                            <xsl:call-template name="check_empty_number">
                                <xsl:with-param name="number" select="r:capital_details/r:paidup_ord_nominal"/>
                            </xsl:call-template>
                        </td>
                        <td class="text-right">
                            <xsl:call-template name="check_empty_number">
                                <xsl:with-param name="number" select="r:capital_details/r:paidup_ord_divided"/>
                            </xsl:call-template>
                        </td>
                        <td class="text-right">
                            <xsl:value-of select="format-number(r:capital_details/r:paidup_ord_amount + r:capital_details/r:paidup_ord_divided,'##,##0.00')" />
                        </td>
                    </tr>
                    <tr>
                        <th class="caption">Preference</th>
                        <td class="text-right">
                            <xsl:call-template name="check_empty_number">
                                <xsl:with-param name="number" select="r:capital_details/r:paidup_pre_amount"/>
                            </xsl:call-template>
                        </td>
                        <td class="text-right">
                            <xsl:call-template name="check_empty_number">
                                <xsl:with-param name="number" select="r:capital_details/r:paidup_pre_nominal"/>
                            </xsl:call-template>
                        </td>
                        <td class="text-right">
                            <xsl:call-template name="check_empty_number">
                                <xsl:with-param name="number" select="r:capital_details/r:paidup_pre_divided"/>
                            </xsl:call-template>
                        </td>
                        <td class="text-right">
                            <xsl:value-of select="format-number(r:capital_details/r:paidup_pre_amount + r:capital_details/r:paidup_pre_divided,'##,##0.00')" />
                        </td>
                    </tr>
                    <tr>
                        <th class="caption">Others</th>
                        <td class="text-right">
                            <xsl:call-template name="check_empty_number">
                                <xsl:with-param name="number" select="r:capital_details/r:paidup_oth_amount"/>
                            </xsl:call-template>
                        </td>
                        <td class="text-right">
                            <xsl:call-template name="check_empty_number">
                                <xsl:with-param name="number" select="r:capital_details/r:paidup_oth_nominal"/>
                            </xsl:call-template>
                        </td>
                        <td class="text-right">
                            <xsl:call-template name="check_empty_number">
                                <xsl:with-param name="number" select="r:capital_details/r:paidup_oth_divided"/>
                            </xsl:call-template>
                        </td>
                        <td class="text-right">
                            <xsl:value-of select="format-number(r:capital_details/r:paidup_oth_amount + r:capital_details/r:paidup_oth_divided,'##,##0.00')" />
                        </td>
                    </tr>                            
        
                </table>
                
                <br/>
                
                <xsl:call-template name="section_b_AIF_director"/>
                <xsl:call-template name="section_b_AIF_shareholder"/>
                <xsl:call-template name="section_b_CH_template"/>
                <xsl:call-template name="section_b_CG_template"/>
                <xsl:call-template name="section_b1_su_subsidiaries_template"/>                                
                
            </xsl:for-each>

        </xsl:if>
        
    </xsl:template>
    <!-- finish section_b_CE -->
    
    <!-- start section_b_Cr_template -->
    <xsl:template name="section_b_Cr_template">
        
        <xsl:if test="r:section_a/r:record[@rpttype = 'Cr']">
        
            <p class="title">FOUND IN CCM INDEX</p>
            
            <table class="table-text-center">
                <tr>
                    <td class="header">Status</td>
                    <td class="header">Registration No.</td>
                    <td class="header">Name / Remark</td>
                </tr>
                <xsl:for-each select="r:section_a/r:record[@rpttype = 'Cr']">
                    <tr>
                        <td rowspan="2">
                            <xsl:value-of select="r:status"/>
                        </td>
                        <td rowspan="2">
                            <xsl:if test="r:ic_lcno != '' and r:lc_checksum != ''">
                                <xsl:value-of select="r:ic_lcno"/>-<xsl:value-of select="r:lc_checksum"/>
                            </xsl:if>
                            <xsl:if test="r:ic_lcno != '' and r:lc_checksum = ''">
                                <xsl:call-template name="check_empty_string">
                                    <xsl:with-param name="value" select="r:ic_lcno"/>
                                </xsl:call-template>
                            </xsl:if>
                        </td>
                        <td>
                            <xsl:call-template name="check_empty_string">
                                <xsl:with-param name="value" select="r:name"/>
                            </xsl:call-template>
                        </td>                        
                    </tr>
                    <tr>
                        <td>
                            <xsl:call-template name="check_empty_string">
                                <xsl:with-param name="value" select="r:remark"/>
                            </xsl:call-template>
                        </td>
                    </tr>
                </xsl:for-each>
            </table>
       
            <br/>
            
        </xsl:if>
        
    </xsl:template>
    <!-- finish section_b_Cr_template -->
    
    <!-- start section_b_CE_previous_names -->
    <xsl:template name="section_b_CE_previous_names">
        <xsl:if test="r:previous_names/r:previous_name">
            <tr>
                <td class="title" colspan="3">PREVIOUS NAME CHANGE</td>
            </tr>
            <tr>
                <td width="10%" class="header text-center">No.</td>
                <td width="60%" class="header">Name</td>
                <td width="30%" class="header text-center">Date Changed</td>
            </tr>
		                    
            <xsl:for-each select="r:previous_names/r:previous_name" >
                <tr>
                    <td class="text-center">
                        <xsl:call-template name="check_empty_string">
                            <xsl:with-param name="value" select="@seq"/>
                        </xsl:call-template>		                    		
                    </td>
                    <td>
                        <xsl:call-template name="check_empty_string">
                            <xsl:with-param name="value" select="r:name"/>
                        </xsl:call-template>		                    		
                    </td>
                    <td class="text-center">
                        <xsl:call-template name="check_empty_string">
                            <xsl:with-param name="value" select="r:change_date"/>
                        </xsl:call-template>		                    		
                    </td>
                </tr>
            </xsl:for-each>       
        </xsl:if>
    </xsl:template>
    <!-- finish section_b_CE_previous_names -->
    
    <!-- start section_b_CE_address_records_ccris_template -->
    <xsl:template name="section_b_CE_address_records_ccris_template">
        
        <xsl:if test="r:ccris_addresses/r:ccris_address">
            
            <xsl:for-each select="r:ccris_addresses/r:ccris_address">
                
                <tr>
                    <td>
                        <xsl:call-template name="check_empty_string">
                            <xsl:with-param name="value" select="."/>
                        </xsl:call-template>
                    </td>
                    <td class="text-center">
                        <xsl:call-template name="check_empty_string">
                            <xsl:with-param name="value" select="@date"/>
                        </xsl:call-template>
                    </td>
                    <td class="text-center">
                        BNM
                    </td>                                                
                </tr>
                
            </xsl:for-each>
            
        </xsl:if>
        
    </xsl:template>
    <!-- finish section_b_CE_address_records_ccris_template -->
    
    <!-- start add empty column center -->
    <xsl:template name="add_empty_column_center">
                
        <xsl:variable name="count">
            <xsl:for-each select="r:accounts/r:account">
                <xsl:if test="position() = last()">
                    <xsl:value-of select="5 - last()"/>
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>
                    
        <xsl:for-each select="(//*)[position() &lt;= $count]">
            <td width="16%" class="text-center">
                -
            </td>
        </xsl:for-each>
                
    </xsl:template>
    <!-- finish add empty column center -->
    
    <!-- start add empty column right -->
    <xsl:template name="add_empty_column_right">
                
        <xsl:variable name="count">
            <xsl:for-each select="r:accounts/r:account">
                <xsl:if test="position() = last()">
                    <xsl:value-of select="5 - last()"/>
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>
                    
        <xsl:for-each select="(//*)[position() &lt;= $count]">
            <td width="16%" class="text-right">
                -
            </td>
        </xsl:for-each>
                
    </xsl:template>
    <!-- finish add empty column right -->
    
    <!-- start section_b_CG -->
    <xsl:template name="section_b_CG_template">        
        <xsl:if test="r:accounts/r:account">                     
            
            <p class="title">FINANCIAL HIGHLIGHTS</p>
            <table class="table">
                <tr>
                    <th class="caption">Financial Year End</th>                                            
                    
                    <xsl:for-each select="r:accounts/r:account">                        
                        <td width="16%" class="text-center">
                            <xsl:call-template name="check_empty_string">
                                <xsl:with-param name="value" select="r:pldd"/>
                            </xsl:call-template>                                                                                                
                        </td>
                    </xsl:for-each>
                    
                    <xsl:call-template name="add_empty_column_center"/>
                </tr>
                <tr>                    
                    <th class="caption">Date of Tabling</th>
                    <xsl:for-each select="r:accounts/r:account">
                        <td width="16%" class="text-center">
                            <xsl:call-template name="check_empty_string">
                                <xsl:with-param name="value" select="r:tabledt"/>
                            </xsl:call-template>
                        </td>                   
                    </xsl:for-each>
                    
                    <xsl:call-template name="add_empty_column_center"/>
                </tr>
                <tr>                    
                    <th class="caption">Auditor</th>
                    <xsl:for-each select="r:accounts/r:account">
                        <td width="16%" class="text-center">
                            <xsl:call-template name="check_empty_string">
                                <xsl:with-param name="value" select="r:auditor_name"/>
                            </xsl:call-template>
                        </td>                   
                    </xsl:for-each>
                    
                    <xsl:call-template name="add_empty_column_center"/>
                </tr>
                <tr>                    
                    <th class="caption">Auditor Address</th>
                    <xsl:for-each select="r:accounts/r:account">
                        <td width="16%" class="text-center">
                            <xsl:call-template name="check_empty_string">
                                <xsl:with-param name="value" select="r:auditor_address"/>
                            </xsl:call-template>
                        </td>                   
                    </xsl:for-each>
                    
                    <xsl:call-template name="add_empty_column_center"/>
                </tr>
                <tr>                    
                    <th class="caption">Exempt Private Company</th>
                    <xsl:for-each select="r:accounts/r:account">
                        <td width="16%" class="text-center">
                            <xsl:if test="r:tabledt">
                                <xsl:if test="r:exempted = 'true'">
                                    <xsl:call-template name="check_empty_string">
                                        <xsl:with-param name="value" select="r:pldd"/>
                                    </xsl:call-template>
                                </xsl:if>                           
                                <xsl:if test="r:exempted = 'false'">
                                    -
                                </xsl:if>
                            </xsl:if>
                            <xsl:if test="not(r:tabledt)">
                                -
                            </xsl:if>
                        </td>            
                    </xsl:for-each>
                    
                    <xsl:call-template name="add_empty_column_center"/>
                </tr>
                <tr>
                    <th class="caption">Unqualified Reports (Y / N)</th>
                    <xsl:for-each select="r:accounts/r:account">
                        <td width="16%" class="text-center">
                            <xsl:if test="r:tabledt">
                                <xsl:if test="r:exempted = 'false'">
                                    <xsl:if test="r:unqrep = 'true'">
                                        Y
                                    </xsl:if>
                                    <xsl:if test="r:unqrep = 'false'">
                                        N
                                    </xsl:if>
                                </xsl:if>
                                <xsl:if test="r:exempted = 'true'">
                                    -
                                </xsl:if>
                            </xsl:if>
                            <xsl:if test="not(r:tabledt)">
                                -
                            </xsl:if>
                        </td>
                    </xsl:for-each>
                    
                    <xsl:call-template name="add_empty_column_center"/>
                </tr>
                <tr>                    
                    <th class="caption">Consolidated Accounts (Y / N)</th>
                    <xsl:for-each select="r:accounts/r:account">
                        <td width="16%" class="text-center">
                            <xsl:if test="r:tabledt">
                                <xsl:if test="r:exempted = 'true'">
                                    -
                                </xsl:if>
                                <xsl:if test="r:exempted = 'false'">
                                    <xsl:if test="r:conac = 'true'">
                                        Y
                                    </xsl:if>
                                    <xsl:if test="r:conac = 'false'">
                                        N
                                    </xsl:if>
                                </xsl:if>
                            </xsl:if>
                            <xsl:if test="not(r:tabledt)">
                                -
                            </xsl:if>
                        </td>
                    </xsl:for-each>
                    
                    <xsl:call-template name="add_empty_column_center"/>
                </tr>
            
                <tr>
                    <td class="header" colspan="6">Balance Sheet</td>
                </tr>
                <tr>                    
                    <th class="caption">Non-Current Assets</th>
                    <xsl:for-each select="r:accounts/r:account">
                        <td width="16%" class="text-right">
                            <xsl:call-template name="check_empty_number_no_zero">
                                <xsl:with-param name="number" select="r:bsclbank"/>
                            </xsl:call-template>
                        </td>
                    </xsl:for-each>
                    
                    <xsl:call-template name="add_empty_column_right"/>
                </tr>
                <tr>                    
                    <th class="caption">- Fixed Assets</th>
                    <xsl:for-each select="r:accounts/r:account">
                        <td width="16%" class="text-right">
                            <xsl:call-template name="check_empty_number_no_zero">
                                <xsl:with-param name="number" select="r:bsfatot"/>
                            </xsl:call-template>
                        </td>
                    </xsl:for-each>
                    
                    <xsl:call-template name="add_empty_column_right"/>
                </tr>
                <tr>                    
                    <th class="caption">- Other Assets</th>
                    <xsl:for-each select="r:accounts/r:account">
                        <td width="16%" class="text-right">
                            <xsl:call-template name="check_empty_number_no_zero">
                                <xsl:with-param name="number" select="r:othass"/>
                            </xsl:call-template>
                        </td>
                    </xsl:for-each>
                    
                    <xsl:call-template name="add_empty_column_right"/>
                </tr>
                <tr>                    
                    <th class="caption">Current Assets</th>
                    <xsl:for-each select="r:accounts/r:account">
                        <td width="16%" class="text-right">
                            <xsl:call-template name="check_empty_number_no_zero">
                                <xsl:with-param name="number" select="r:bscatot"/>
                            </xsl:call-template>
                        </td>
                    </xsl:for-each>
                    
                    <xsl:call-template name="add_empty_column_right"/>
                </tr>
           
                <tr>                    
                    <th class="caption">Total Assets</th>
                    <xsl:for-each select="r:accounts/r:account">
                        <td width="16%" class="text-right bold">
                            <xsl:if test="r:totass != r:tot">
                                *
                            </xsl:if>
                            <xsl:call-template name="check_empty_number_no_zero">
                                <xsl:with-param name="number" select="r:totass"/>
                            </xsl:call-template>
                        </td>
                    </xsl:for-each>
                    
                    <xsl:call-template name="add_empty_column_right"/>
                </tr>
            
                <tr>
                    <th class="caption">- YoY Growth</th>
                    <xsl:for-each select="r:accounts/r:account">
                        <td width="16%" class="text-right bold">
                            <xsl:call-template name="calcYoY">
                                <xsl:with-param name="num1" select="r:totass"/>
                                <xsl:with-param name="num2" select="following-sibling::*[name() = name(current())]/r:totass"/>
                            </xsl:call-template>            		
                        </td>            		
                    </xsl:for-each>
                    
                    <xsl:call-template name="add_empty_column_right"/>
                </tr>
                <tr>                    
                    <th class="caption">Non-current Liabilities</th>
                    <xsl:for-each select="r:accounts/r:account">
                        <td width="16%" class="text-right">
                            <xsl:call-template name="check_empty_number_no_zero">
                                <xsl:with-param name="number" select="r:bsclstd"/>
                            </xsl:call-template>
                        </td>
                    </xsl:for-each>
                    
                    <xsl:call-template name="add_empty_column_right"/>
                </tr>            	
            
                <tr>                    
                    <th class="caption">Current Liabilities</th>
                    <xsl:for-each select="r:accounts/r:account">
                        <td width="16%" class="text-right">
                            <xsl:call-template name="check_empty_number_no_zero">
                                <xsl:with-param name="number" select="r:curlib"/>
                            </xsl:call-template>
                        </td>
                    </xsl:for-each>
                    
                    <xsl:call-template name="add_empty_column_right"/>
                </tr>
                <tr>                    
                    <th class="caption">Long Term Liabilities</th>
                    <xsl:for-each select="r:accounts/r:account">
                        <td width="16%" class="text-right">
                            <xsl:call-template name="check_empty_number_no_zero">
                                <xsl:with-param name="number" select="r:bsslltd"/>
                            </xsl:call-template>
                        </td>
                    </xsl:for-each>
                    
                    <xsl:call-template name="add_empty_column_right"/>
                </tr>            
                <tr>                    
                    <th class="caption">Total Liabilities</th>
                    <xsl:for-each select="r:accounts/r:account">
                        <td width="16%" class="text-right bold">
                            <xsl:call-template name="check_empty_number_no_zero">
                                <xsl:with-param name="number" select="r:totlib"/>
                            </xsl:call-template>
                        </td>
                    </xsl:for-each>
                    
                    <xsl:call-template name="add_empty_column_right"/>
                </tr>
                <tr>
                    <th class="caption">- YoY Growth</th>
                    <xsl:for-each select="r:accounts/r:account">
                        <td width="16%" class="text-right bold">
                            <xsl:call-template name="calcYoY">
                                <xsl:with-param name="num1" select="r:totlib"/>
                                <xsl:with-param name="num2" select="following-sibling::*[name() = name(current())]/r:totlib"/>
                            </xsl:call-template>            		
                        </td>            		
                    </xsl:for-each>
                    
                    <xsl:call-template name="add_empty_column_right"/>
                </tr>
                        
                <tr>                    
                    <th class="caption">Share Capital</th>
                    <xsl:for-each select="r:accounts/r:account">
                        <td width="16%" class="text-right">
                            <xsl:call-template name="check_empty_number_no_zero">
                                <xsl:with-param name="number" select="r:bsqpuc"/>
                            </xsl:call-template>
                        </td>
                    </xsl:for-each>
                    
                    <xsl:call-template name="add_empty_column_right"/>
                </tr>
                <tr>                    
                    <th class="caption">Share Premium</th>
                    <xsl:for-each select="r:accounts/r:account">
                        <td width="16%" class="text-right">
                            <xsl:call-template name="check_empty_number_no_zero">
                                <xsl:with-param name="number" select="r:bsqres"/>
                            </xsl:call-template>
                        </td>
                    </xsl:for-each>
                    
                    <xsl:call-template name="add_empty_column_right"/>
                </tr>
                <tr>                    
                    <th class="caption">Reserves</th>
                    <xsl:for-each select="r:accounts/r:account">
                        <td width="16%" class="text-right">
                            <xsl:call-template name="check_empty_number_no_zero">
                                <xsl:with-param name="number" select="r:bsqupro"/>
                            </xsl:call-template>
                        </td>
                    </xsl:for-each>
                    
                    <xsl:call-template name="add_empty_column_right"/>
                </tr>
                <tr>                    
                    <th class="caption">Minority Interest</th>
                    <xsl:for-each select="r:accounts/r:account">
                        <td width="16%" class="text-right">
                            <xsl:call-template name="check_empty_number_no_zero">
                                <xsl:with-param name="number" select="r:bsqmint"/>
                            </xsl:call-template>
                        </td>
                    </xsl:for-each>
                    
                    <xsl:call-template name="add_empty_column_right"/>
                </tr>
            
                <tr>                    
                    <th class="caption">Net Worth</th>
                    <xsl:for-each select="r:accounts/r:account">
                        <td width="16%" class="text-right bold">
                            <xsl:call-template name="check_empty_number_no_zero">
                                <xsl:with-param name="number" select="r:networth"/>
                            </xsl:call-template>
                        </td>
                    </xsl:for-each>
                    
                    <xsl:call-template name="add_empty_column_right"/>
                </tr>
                <tr>
                    <th class="caption">- YoY Growth</th>
                    <xsl:for-each select="r:accounts/r:account">
                        <td width="16%" class="text-right bold">
                            <xsl:call-template name="calcYoY">
                                <xsl:with-param name="num1" select="r:networth"/>
                                <xsl:with-param name="num2" select="following-sibling::*[name() = name(current())]/r:networth"/>
                            </xsl:call-template>            		
                        </td>            		
                    </xsl:for-each>
                    
                    <xsl:call-template name="add_empty_column_right"/>
                </tr>
                <tr>                    
                    <th class="caption">Total (TL + NW + MI)</th>
                    <xsl:for-each select="r:accounts/r:account">
                        <td width="16%" class="text-right bold">
                            <xsl:call-template name="check_empty_number_no_zero">
                                <xsl:with-param name="number" select="r:tot"/>
                            </xsl:call-template>
                        </td>
                    </xsl:for-each>
                    
                    <xsl:call-template name="add_empty_column_right"/>
                </tr>
            
                <tr>
                    <td class="header" colspan="6">Income Statement</td>
                </tr>
                <tr>                    
                    <th class="caption">Revenue</th>
                    <xsl:for-each select="r:accounts/r:account">
                        <td width="16%" class="text-right">
                            <xsl:call-template name="check_empty_number_no_zero">
                                <xsl:with-param name="number" select="r:turnover"/>
                            </xsl:call-template>
                        </td>
                    </xsl:for-each>
                    
                    <xsl:call-template name="add_empty_column_right"/>
                </tr>
           
                <tr>                    
                    <th class="caption">- YoY Growth</th>               
                    <xsl:for-each select="r:accounts/r:account">
                        <td width="16%" class="text-right bold">
                            <xsl:call-template name="check_empty_string">
                                <xsl:with-param name="value" select="r:turnover_growth"/>
                            </xsl:call-template>
                        </td>
                    </xsl:for-each>
                    
                    <xsl:call-template name="add_empty_column_right"/>
                </tr>
            
                <tr>                    
                    <th class="caption">Profit / (loss) Before Tax</th>
                    <xsl:for-each select="r:accounts/r:account">
                        <td width="16%" class="text-right">
                            <xsl:call-template name="check_empty_number_no_zero">
                                <xsl:with-param name="number" select="r:plnpbt"/>
                            </xsl:call-template>
                        </td>
                    </xsl:for-each>
                    
                    <xsl:call-template name="add_empty_column_right"/>
                </tr>
            
                <tr>
                    <th class="caption">- YoY Growth</th>
                    <xsl:for-each select="r:accounts/r:account">
                        <td width="16%" class="text-right bold">
                            <xsl:call-template name="calcYoY">
                                <xsl:with-param name="num1" select="r:plnpbt"/>
                                <xsl:with-param name="num2" select="following-sibling::*[name() = name(current())]/r:plnpbt"/>
                            </xsl:call-template>            		
                        </td>            		
                    </xsl:for-each>
                    
                    <xsl:call-template name="add_empty_column_right"/>
                </tr>
            
                <tr>                    
                    <th class="caption">Profit / (loss) After Tax</th>
                    <xsl:for-each select="r:accounts/r:account">
                        <td width="16%" class="text-right">
                            <xsl:call-template name="check_empty_number_no_zero">
                                <xsl:with-param name="number" select="r:plnpat"/>
                            </xsl:call-template>
                        </td>
                    </xsl:for-each>
                    
                    <xsl:call-template name="add_empty_column_right"/>
                </tr>
            
                <tr>
                    <th class="caption">- YoY Growth</th>
                    <xsl:for-each select="r:accounts/r:account">
                        <td width="16%" class="text-right bold">
                            <xsl:call-template name="calcYoY">
                                <xsl:with-param name="num1" select="r:plnpat"/>
                                <xsl:with-param name="num2" select="following-sibling::*[name() = name(current())]/r:plnpat"/>
                            </xsl:call-template>            		
                        </td>            		
                    </xsl:for-each>
                    
                    <xsl:call-template name="add_empty_column_right"/>
                </tr>
            
                <tr>                    
                    <th class="caption">Net dividend</th>
                    <xsl:for-each select="r:accounts/r:account">
                        <td width="16%" class="text-right bold">
                            <xsl:call-template name="check_empty_number_no_zero">
                                <xsl:with-param name="number" select="r:plnetdiv"/>
                            </xsl:call-template>
                        </td>
                    </xsl:for-each>
                    
                    <xsl:call-template name="add_empty_column_right"/>
                </tr>
            
                <tr>                    
                    <th class="caption">Minority Interest</th>
                    <xsl:for-each select="r:accounts/r:account">
                        <td width="16%" class="text-right">
                            <xsl:call-template name="check_empty_number_no_zero">
                                <xsl:with-param name="number" select="r:plminin"/>
                            </xsl:call-template>
                        </td>
                    </xsl:for-each>
                    
                    <xsl:call-template name="add_empty_column_right"/>
                </tr>
            
            
                <tr>
                    <td class="header" colspan="6">Liquidity Ratios</td>
                </tr>
            
                <tr>                    
                    <th class="caption">Current Ratio</th>
                
                    <xsl:for-each select="r:accounts/r:account">
                        <td width="16%" class="text-right">
                            <xsl:call-template name="check_empty_string">
                                <xsl:with-param name="value" select="r:currat"/>
                            </xsl:call-template>
                        </td>
                    </xsl:for-each>
                    
                    <xsl:call-template name="add_empty_column_right"/>
                </tr>
            
                <tr>                    
                    <th class="caption">Working Capital Days</th>                
                    <xsl:for-each select="r:accounts/r:account">
                        <td width="16%" class="text-right">
                            <xsl:call-template name="checkNaN">
                                <xsl:with-param name="number" select="((r:bscatot - r:curlib) * 365) div r:turnover" />
                            </xsl:call-template>
                        </td>
                    </xsl:for-each>
                    
                    <xsl:call-template name="add_empty_column_right"/>
                </tr>
            
                <tr>
                    <td class="header" colspan="6">Profitability Ratios</td>
                </tr>
            
                <tr>                    
                    <th class="caption">Return On Assets (ROA)</th>                
                    <xsl:for-each select="r:accounts/r:account">
                        <td width="16%" class="text-right">
                            <xsl:variable name="roa">
                                <xsl:call-template name="checkNaN">
                                    <xsl:with-param name="number" select="r:plnpat div r:totass * 100" />
                                </xsl:call-template>
                            </xsl:variable>
                            <xsl:copy-of select="$roa" />
                            <xsl:if test="number($roa) = $roa">%</xsl:if>
                        </td>
                    </xsl:for-each>
                    
                    <xsl:call-template name="add_empty_column_right"/>
                </tr>
            
                <tr>                    
                    <th class="caption">Return On Equity (ROE)</th>                
                    <xsl:for-each select="r:accounts/r:account">
                        <td width="16%" class="text-right">
                            <xsl:call-template name="check_empty_string">
                                <xsl:with-param name="value" select="r:return_on_equity"/>
                            </xsl:call-template>
                        </td>
                    </xsl:for-each>
                    
                    <xsl:call-template name="add_empty_column_right"/>
                </tr>
            
                <tr>                    
                    <th class="caption">PBT Margin</th>                
                    <xsl:for-each select="r:accounts/r:account">
                        <td width="16%" class="text-right">
                            <xsl:call-template name="check_empty_string">
                                <xsl:with-param name="value" select="r:profit_margin"/>
                            </xsl:call-template>
                        </td>
                    </xsl:for-each>
                    
                    <xsl:call-template name="add_empty_column_right"/>
                </tr>
                <tr>                    
                    <th class="caption">PAT Margin</th>                
                    <xsl:for-each select="r:accounts/r:account">
                        <td width="16%" class="text-right">
                            <xsl:variable name="pat">
                                <xsl:call-template name="checkNaN">
                                    <xsl:with-param name="number" select="format-number(r:plnpat div r:turnover * 100,'##,##0.00')" />
                                </xsl:call-template>
                            </xsl:variable>
                            <xsl:copy-of select="$pat" />
                            <xsl:if test="number($pat) = $pat">%</xsl:if>
                        </td>
                    </xsl:for-each>
                    
                    <xsl:call-template name="add_empty_column_right"/>
                </tr>
            
                <tr>
                    <td class="header" colspan="6">Other Ratios</td>
                </tr>
            
                <tr>                    
                    <th class="caption">Asset Turnover Ratio</th>                
                    <xsl:for-each select="r:accounts/r:account">
                        <td width="16%" class="text-right">
                            <xsl:call-template name="checkNaN">
                                <xsl:with-param name="number" select="r:turnover div r:totass" />
                            </xsl:call-template>
                        </td>
                    </xsl:for-each>
                    
                    <xsl:call-template name="add_empty_column_right"/>
                </tr>
            
                <tr>                    
                    <th class="caption">Gearing Ratio</th>                
                    <xsl:for-each select="r:accounts/r:account">
                        <td width="16%" class="text-right">
                            <xsl:call-template name="checkNaN">
                                <xsl:with-param name="number" select="r:totlib div r:networth"/>
                            </xsl:call-template>
                        </td>
                    </xsl:for-each>
                    
                    <xsl:call-template name="add_empty_column_right"/>
                </tr>
            
                <tr>                    
                    <th class="caption">Dividend Pay-out Ratio</th>
                    <xsl:for-each select="r:accounts/r:account">
                        <td width="16%" class="text-right">
                            <xsl:call-template name="check_empty_number_no_zero">
                                <xsl:with-param name="number" select="r:dividen_pay_out"/>
                            </xsl:call-template>
                        </td>
                    </xsl:for-each>
                    
                    <xsl:call-template name="add_empty_column_right"/>
                </tr>
            
                <tr>                    
                    <th class="caption">Earnings per Share</th>                
                    <xsl:for-each select="r:accounts/r:account">
                        <td width="16%" class="text-right">
                            <xsl:variable name="totEquity">
                                <xsl:value-of select="sum(../../r:directors/r:director[r:position = 'DS' or r:position = 'SO']/r:equity)" />
                            </xsl:variable>
                            <xsl:call-template name="checkNaN">
                                <xsl:with-param name="number" select="r:plnpat div $totEquity"/>
                            </xsl:call-template>
                        </td>
                    </xsl:for-each>
                    
                    <xsl:call-template name="add_empty_column_right"/>
                </tr>
            
                <tr>                    
                    <th class="caption">Dividend per Share</th>
                    <xsl:for-each select="r:accounts/r:account">
                        <td width="16%" class="text-right">
                            <xsl:call-template name="check_empty_number_no_zero">
                                <xsl:with-param name="number" select="r:dividen_per_share"/>
                            </xsl:call-template>
                        </td>
                    </xsl:for-each>
                    
                    <xsl:call-template name="add_empty_column_right"/>
                </tr>                
            </table>
            
            <p class="notice">* The figures provided under the CCM’s computer printout search are indicative only and do not necessarily balance.</p>
            
            <br/>
            
        </xsl:if>
        
    </xsl:template>
    <!-- finish section_b_CG -->

    <!-- start section_b_CH -->
    <xsl:template name="section_b_CH_template">
        
        <xsl:if test="r:charges/r:charge">        
            <p class="title">COMPANY CHARGES</p>
            <xsl:if test="r:charges/r:charge/r:name">
                <p class="notice">Note: U=Unsatisfied; S=Fully Satisfied; R=Fully Released; P=Partly Released</p>            
                <table class="table">
                    <tr>
                        <td width="5%" class="header">No.</td>
                        <td width="14%" class="header text-center">Amount</td>
                        <td width="15%" class="header text-center">Created Date</td>
                        <td width="10%" class="header text-center">Status</td>
                        <td width="56%" class="header text-center">Chargee</td>
                    </tr>
                
                    <xsl:for-each select="r:charges/r:charge">
                        <tr>
                            <td class="text-center">
                                <xsl:value-of select="./@seq"/>.
                            </td>
                            <td class="text-right">
                                <xsl:choose>
                                    <xsl:when test="r:charge_amount = '' or number(r:charge_amount) = 0">
                                        Open Charge
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:call-template name="check_empty_number">
                                            <xsl:with-param name="number" select="r:charge_amount"/>
                                        </xsl:call-template>
                                    </xsl:otherwise>
                                </xsl:choose>                        
                            </td>
                            <td class="text-center">
                                <xsl:call-template name="check_empty_string">
                                    <xsl:with-param name="value" select="r:charge_date"/>
                                </xsl:call-template>
                            </td>
                            <td class="text-center">
                                <xsl:call-template name="check_empty_string">
                                    <xsl:with-param name="value" select="r:status"/>
                                </xsl:call-template>
                            </td>
                            <td class="text-center">
                                <xsl:call-template name="check_empty_string">
                                    <xsl:with-param name="value" select="r:name"/>
                                </xsl:call-template>
                            </td>
                        </tr>
                    </xsl:for-each>
                </table>
                <p class="notice">Note: Total Company Charges (RM): <xsl:value-of select="format-number(sum(r:charges/r:charge/r:charge_amount),'##,##0.00')" /></p>
            </xsl:if>
            <xsl:if test="not(r:charges/r:charge/r:name)">
                <p class="info">No Information Available</p>
            </xsl:if>
            <br/>
        </xsl:if>
        
    </xsl:template>
    <!-- finish section_b_CH -->

    <!-- start section_b1_subreport_template -->
    <xsl:template name="section_b1_subreport_template">
        
        <xsl:call-template name="section_b1_cj_template"/>
        <xsl:call-template name="section_b1_if_template"/>
        <xsl:call-template name="section_b1_ik_template"/>
        <xsl:call-template name="section_b1_ir_template"/>
        <xsl:call-template name="section_b1_su_subsidiaries_template"/>
        
    </xsl:template>
    <!-- finish section_b1_subreport_template -->

    <!-- start section_b1_directorships_and_business_interests_template -->
    <xsl:template name="section_b1_directorships_and_business_interests_template">

        <table class="table">
            <tr>
                <td class="header text-center" width="5%">No</td>
                <td class="header text-center" width="22%">Company</td>
                <td class="header text-center" width="20%">Position</td>
                <td class="header text-center" width="10%">Appoint</td>
                <td class="header text-center" width="14%">Resign Date</td>
                <td class="header text-center" width="13%">Profit After Tax (RM)</td>
                <td class="header text-center" width="8%">Year</td>
                <td class="header text-center" width="8%">Status</td>
            </tr>
                            
            <xsl:for-each select="r:section_c/r:record">
                <tr>
                    <td class="text-center">
                        <xsl:value-of select="position()"/>.
                    </td>
                    <td class="text-center">
                        <xsl:call-template name="check_empty_string">
                            <xsl:with-param name="value" select="r:company_name"/>
                        </xsl:call-template>
                    </td>
                    <td class="text-center">
                        <xsl:call-template name="check_empty_string">
                            <xsl:with-param name="value" select="r:position"/>
                        </xsl:call-template>
                    </td>
                    <td class="text-center">
                        <xsl:call-template name="check_empty_string">
                            <xsl:with-param name="value" select="r:appoint"/>
                        </xsl:call-template>
                    </td>
                    <td class="text-center">
                        <xsl:call-template name="check_empty_string">
                            <xsl:with-param name="value" select="r:resign"/>
                        </xsl:call-template>
                    </td>
                    <td class="text-right">
                        <xsl:call-template name="check_empty_number">
                            <xsl:with-param name="number" select="r:profit_after_tax"/>
                        </xsl:call-template>
                    </td>
                    <td class="text-center">
                        <xsl:call-template name="check_empty_string">
                            <xsl:with-param name="value" select="r:latest_financial_year"/>
                        </xsl:call-template>
                    </td>
                    <td class="text-center">
                        <xsl:call-template name="check_empty_string">
                            <xsl:with-param name="value" select="r:status"/>
                        </xsl:call-template>
                    </td>
                </tr>
            </xsl:for-each>
        </table>  
            
        <br/>

    </xsl:template>
    <!-- finish section_b1_directorships_and_business_interests_template -->

    <!-- start section_b1_cj_template -->
    <xsl:template name="section_b1_cj_template">
    
        <xsl:if test="r:section_a/r:record[@rpttype = 'CJ']">
            
            <xsl:for-each select="r:section_a/r:record[@rpttype = 'CJ']">
                
                <xsl:for-each select="r:partners/r:partner">
                    
                    <p class="title">CURRENT BUSINESS OWNER(S) / PARTNER(S)</p>
                    
                    <table class="table">
                        <tr>
                            <th class="caption">Name</th>
                            <td class="long-content" colspan="3">
                                <xsl:call-template name="check_empty_string">
                                    <xsl:with-param name="value" select="r:name"/>
                                </xsl:call-template>
                            </td>
                        </tr>
                        <tr>
                            <th class="caption">New ID No.</th>
                            <td class="short-content">
                                <xsl:call-template name="check_empty_string">
                                    <xsl:with-param name="value" select="r:nic"/>
                                </xsl:call-template>
                            </td>
                            <th class="caption">Old ID No.</th>
                            <td class="short-content">
                                <xsl:call-template name="check_empty_string">
                                    <xsl:with-param name="value" select="r:ic"/>
                                </xsl:call-template>
                            </td>
                        </tr>
                        <tr>
                            <th class="caption">Address</th>
                            <td class="long-content" colspan="3">
                                <xsl:call-template name="check_empty_string">
                                    <xsl:with-param name="value" select="r:address"/>
                                </xsl:call-template>
                            </td>
                        </tr>
                        <tr>
                            <th class="caption">Position</th>
                            <td class="short-content">
                                <xsl:if test="r:position = 'SP'">
                                    Sole Proprietor
                                </xsl:if>
                                <xsl:if test="r:position = 'PN'">
                                    Partner
                                </xsl:if>
                            </td>
                            <th class="caption">Appointed</th>
                            <td class="short-content">
                                <xsl:call-template name="check_empty_string">
                                    <xsl:with-param name="value" select="r:appoint_date"/>
                                </xsl:call-template>
                            </td>
                        </tr>
                        <tr>
                            <th class="caption">Remark</th>
                            <td class="long-content" colspan="3">
                                <xsl:call-template name="check_empty_string">
                                    <xsl:with-param name="value" select="r:remark"/>
                                </xsl:call-template>
                            </td>
                        </tr>
                    </table>
                    
                </xsl:for-each>                                
                
            </xsl:for-each>
            
            <p class="notice">Note: The information above have been extracted from ROB computer printout search. We do not warrant as to its accuracy, correctness or completeness. If there are inconsistencies, inaccuracies or missing details or information, please conduct a further probe.</p>
            
            <br/>
            
        </xsl:if>
        
    </xsl:template>
    <!-- finish section_b1_cj_template -->

    <!-- start section_b1_if_template -->
    <xsl:template name="section_b1_if_template">
        
        <xsl:if test="r:section_c/r:record[@rpttype = 'IF']">
            
            <xsl:for-each select="r:section_c/r:record[@rpttype = 'IF']">
                
                <p class="title">
                    <xsl:value-of select="@seq"/>.&#160;
                    <xsl:value-of select="r:company_name"/>
                    <xsl:if test="r:local != '' and r:locala != ''">
                        (<xsl:value-of select="r:local"/>-<xsl:value-of select="r:locala"/>)
                    </xsl:if>
                    <xsl:if test="r:local != '' and r:locala = ''">
                        (<xsl:value-of select="r:local"/>)
                    </xsl:if>
                </p>
                
                <table class="table">
                    <tr>
                        <th class="caption">Status</th>
                        <td class="long-content" colspan="3">
                            <xsl:call-template name="check_empty_string">
                                <xsl:with-param name="value" select="r:status"/>
                            </xsl:call-template>
                        </td>
                    </tr>
                    <tr>
                        <th class="caption">Nature Of Business</th>
                        <td class="long-content" colspan="3">
                            <xsl:call-template name="check_empty_string">
                                <xsl:with-param name="value" select="r:object"/>
                            </xsl:call-template>
                        </td>
                    </tr>
                    <tr>
                        <th class="caption">Incorporation</th>
                        <td class="short-content">
                            <xsl:call-template name="check_empty_string">
                                <xsl:with-param name="value" select="r:incdate"/>
                            </xsl:call-template>
                        </td>
                        
                        <th class="caption">Paid-Up</th>
                        <td class="short-content">
                            <xsl:call-template name="check_empty_number">
                                <xsl:with-param name="number" select="r:paidup"/>
                            </xsl:call-template>
                        </td>
                    </tr>
                    <tr>
                        <th class="caption">CCM Dated</th>
                        <td class="long-content" colspan="3">
                            <xsl:call-template name="check_empty_string">
                                <xsl:with-param name="value" select="r:cpo_date"/>
                            </xsl:call-template>
                        </td>
                    </tr>
                    <tr>
                        <th class="caption">Name</th>
                        <td class="long-content" colspan="3">
                            <xsl:call-template name="check_empty_string">
                                <xsl:with-param name="value" select="r:name"/>
                            </xsl:call-template>
                        </td>
                    </tr>
                    <tr>
                        <th class="caption">New ID No. / Passport</th>
                        <td class="short-content">
                            <xsl:call-template name="check_empty_string">
                                <xsl:with-param name="value" select="r:nic_brno"/>
                            </xsl:call-template>
                        </td>
                        
                        <th class="caption">ID No.</th>
                        <td class="short-content">
                            <xsl:call-template name="check_empty_string">
                                <xsl:with-param name="string" select="r:ic_lcno"/>
                            </xsl:call-template>
                        </td>
                    </tr>
                    <tr>
                        <th class="caption">Position</th>
                        <td class="short-content">
                            <xsl:call-template name="check_empty_string">
                                <xsl:with-param name="value" select="r:position"/>
                            </xsl:call-template>
                        </td>
                        
                        <th class="caption">Shares</th>
                        <td class="short-content">
                            <xsl:call-template name="check_empty_number">
                                <xsl:with-param name="number" select="r:shares"/>
                            </xsl:call-template>
                        </td>
                    </tr>
                    <tr>
                        <th class="caption">Appointed</th>
                        <td class="short-content">
                            <xsl:call-template name="check_empty_string">
                                <xsl:with-param name="value" select="r:appoint"/>
                            </xsl:call-template>
                        </td>
                        
                        <th class="caption">Resigned</th>
                        <td class="short-content">
                            <xsl:call-template name="check_empty_string">
                                <xsl:with-param name="value" select="r:resign"/>
                            </xsl:call-template>
                        </td>
                    </tr>
                    <tr>
                        <th class="caption">Address</th>
                        <td class="long-content" colspan="3">
                            <xsl:call-template name="check_empty_string">
                                <xsl:with-param name="value" select="r:addr"/>
                            </xsl:call-template>
                        </td>
                    </tr>
                    <tr>
                        <th class="caption">Remark</th>
                        <td class="long-content" colspan="3">
                            <xsl:call-template name="check_empty_string">
                                <xsl:with-param name="value" select="r:remark"/>
                            </xsl:call-template>
                        </td>
                    </tr>
                </table>
                
                <br/>
                
            </xsl:for-each>                        
            
        </xsl:if>
        
    </xsl:template>
    <!-- finish section_b1_if_template -->

    <!-- start section_b1_ik_template -->
    <xsl:template name="section_b1_ik_template">
        
        <xsl:if test="r:section_c/r:record[@rpttype = 'IK']">
            
            <xsl:for-each select="r:section_c/r:record[@rpttype = 'IK']">
                
                <p class="title">
                    <xsl:value-of select="@seq"/>.&#160;
                    <xsl:value-of select="r:company_name"/>
                    <xsl:if test="r:local != '' and r:locala != ''">
                        (<xsl:value-of select="r:local"/>-<xsl:value-of select="r:locala"/>)
                    </xsl:if>
                    <xsl:if test="r:local != '' and r:locala = ''">
                        (<xsl:value-of select="r:local"/>)
                    </xsl:if>
                </p>
                
                <table class="table">
                    <tr>
                        <th class="caption">Status</th>
                        <td class="long-content" colspan="3">
                            <xsl:call-template name="check_empty_string">
                                <xsl:with-param name="value" select="r:status"/>
                            </xsl:call-template>
                        </td>
                    </tr>
                    <tr>
                        <th class="caption">Nature Of Business</th>
                        <td class="long-content" colspan="3">
                            <xsl:call-template name="check_empty_string">
                                <xsl:with-param name="value" select="r:object"/>
                            </xsl:call-template>
                        </td>
                    </tr>
                    <tr>
                        <th class="caption">Registration</th>
                        <td class="short-content">
                            <xsl:call-template name="check_empty_string">
                                <xsl:with-param name="value" select="r:incdate"/>
                            </xsl:call-template>
                        </td>
                        
                        <th class="caption">Expiry Date</th>
                        <td class="short-content">
                            <xsl:call-template name="check_empty_string">
                                <xsl:with-param name="value" select="r:expdate"/>
                            </xsl:call-template>
                        </td>
                    </tr>                    
                    <tr>
                        <th class="caption">Name</th>
                        <td class="long-content" colspan="3">
                            <xsl:call-template name="check_empty_string">
                                <xsl:with-param name="value" select="r:name"/>
                            </xsl:call-template>
                        </td>
                    </tr>
                    <tr>
                        <th class="caption">New ID No. / Passport</th>
                        <td class="short-content">
                            <xsl:call-template name="check_empty_string">
                                <xsl:with-param name="value" select="r:nic_brno"/>
                            </xsl:call-template>
                        </td>
                        
                        <th class="caption">ID No.</th>
                        <td class="short-content">
                            <xsl:call-template name="check_empty_string">
                                <xsl:with-param name="value" select="r:ic_lcno"/>
                            </xsl:call-template>
                        </td>
                    </tr>
                    <tr>
                        <th class="caption">Position</th>
                        <td class="short-content">
                            <xsl:call-template name="check_empty_string">
                                <xsl:with-param name="value" select="r:position"/>
                            </xsl:call-template>
                        </td>
                        
                        <th class="caption">CCM Date</th>
                        <td class="short-content">
                            <xsl:call-template name="check_empty_string">
                                <xsl:with-param name="value" select="r:cpo_date"/>
                            </xsl:call-template>
                        </td>
                    </tr>
                    <tr>
                        <th class="caption">Address</th>
                        <td class="long-content" colspan="3">
                            <xsl:call-template name="check_empty_string">
                                <xsl:with-param name="value" select="r:addr"/>
                            </xsl:call-template>
                        </td>
                    </tr>
                    <tr>
                        <th class="caption">Remark</th>
                        <td class="long-content" colspan="3">
                            <xsl:call-template name="check_empty_string">
                                <xsl:with-param name="value" select="r:remark"/>
                            </xsl:call-template>
                        </td>
                    </tr>
                </table>
                
                <br/>
                
            </xsl:for-each>                        
            
        </xsl:if>
        
    </xsl:template>
    <!-- finish section_b1_ik_template -->

    <!-- start section_b1_ir_template -->
    <xsl:template name="section_b1_ir_template">
        
        <xsl:if test="r:section_a/r:record[@rpttype = 'Ir']">
        
            <p class="title">FOUND IN ROB INDEX</p>
            
            <table class="table">
                <tr>
                    <td class="header text-center" width="30%">Reg No.</td>
                    <td class="header text-center" width="70%">Name / Address</td>
                </tr>
                <xsl:for-each select="r:section_a/r:record[@rpttype = 'Ir']">
                    <tr>
                        <td class="text-center" rowspan="2">
                            <xsl:call-template name="check_empty_string">
                                <xsl:with-param name="value" select="r:register_no"/>
                            </xsl:call-template>
                        </td>
                        <td class="text-center">
                            <xsl:call-template name="check_empty_string">
                                <xsl:with-param name="value" select="r:name"/>
                            </xsl:call-template>
                        </td>
                    </tr>
                    <tr>
                        <td class="text-center">
                            <xsl:call-template name="check_empty_string">
                                <xsl:with-param name="value" select="r:addr"/>
                            </xsl:call-template>
                        </td>
                    </tr>
                </xsl:for-each>
            </table>
       
            <br/>
            
        </xsl:if>
        
    </xsl:template>
    <!-- finish section_b1_ir_template -->

    <!-- start section_b1_su_subsidiaries_template -->
    <xsl:template name="section_b1_su_subsidiaries_template">
        
        <xsl:if test="r:section_c/r:record[@rpttype = 'SU']">
        
            <p class="title">RELATED COMPANIES / SUBSIDIARIES</p>
            
            <table class="table">
                <tr>
                    <td class="header text-center" width="2%">No.</td>
                    <td class="header text-center" width="30%">Name</td>
                    <td class="header text-center" width="24%">CR / BR No.</td>
                    <td class="header text-right" width="22%">Paid Up Capital (RM)</td>
                    <td class="header text-right" width="22%">Shareholding (%)</td>
                </tr>
                <xsl:for-each select="r:section_c/r:record[@rpttype = 'SU']">
                    <tr>
                        <td class="text-center">
                            <xsl:value-of select="@seq"/>.
                        </td>
                        <td class="text-center">
                            <xsl:call-template name="check_empty_string">
                                <xsl:with-param name="value" select="r:company_name"/>
                            </xsl:call-template>
                        </td>
                        <td class="text-center">
                            <xsl:if test="r:local != '' and r:locala != ''">
                                <xsl:value-of select="r:local"/>-<xsl:value-of select="r:locala"/>
                            </xsl:if>
                            <xsl:if test="r:local != '' and r:locala = ''">
                                <xsl:value-of select="r:local"/>
                            </xsl:if>
                        </td>
                        <td class="text-right">
                            <xsl:call-template name="check_empty_number">
                                <xsl:with-param name="number" select="r:paidup"/>
                            </xsl:call-template>
                        </td>
                        <td class="text-right">
                            <xsl:call-template name="check_empty_number">
                                <xsl:with-param name="number" select="r:shares"/>
                            </xsl:call-template>
                        </td>
                    </tr>
                </xsl:for-each>
            </table>
       
            <br/>
            
        </xsl:if>
        
    </xsl:template>
    <!-- finish section_b1_su_subsidiaries_template -->    

    <!-- start section_b2_subreport_template -->
    <xsl:template name="section_b2_subreport_template">
        
        <xsl:call-template name="section_b2_address_records_template"/>
        
    </xsl:template>
    <!-- finish section_b2_subreport_template -->

    <!-- start section_b2_address_records_template -->
    <xsl:template name="section_b2_address_records_template">
        
        <table class="table">
        
            <xsl:if test="r:section_a/r:record/r:addr or r:ccris_addresses/r:ccris_address">

                <tr>
                    <td class="header" width="60%">Address</td>
                    <td class="header text-center" width="15%">Last Updated</td>
                    <td class="header text-center" width="25%">Source</td>
                </tr>
                
                <xsl:for-each select="r:section_a/r:record">
                    
                    <tr>
                        <td>
                            <xsl:call-template name="check_empty_string">
                                <xsl:with-param name="value" select="r:addr"/>
                            </xsl:call-template>
                        </td>
                        <td class="text-center">
                            <xsl:call-template name="check_empty_string">
                                <xsl:with-param name="value" select="r:cpo_date"/>
                            </xsl:call-template>
                        </td>
                        <td class="text-center">
                            <xsl:call-template name="check_empty_string">
                                <xsl:with-param name="value" select="r:source"/>
                            </xsl:call-template>
                        </td>                                                
                    </tr>
                
                    <xsl:call-template name="section_b2_address_records_ccris_template"/>
                
                </xsl:for-each>
            
            </xsl:if>
            
            <xsl:if test="r:section_a/r:record/r:addr = '' or r:ccris_addresses/r:ccris_address = ''">
                
                <tr>
                    <td colspan="3">
                        No Information Available
                    </td>
                </tr>
                
            </xsl:if>
                
        </table>                            
        
        <br/>
        
    </xsl:template>
    <!-- finish section_b2_address_records_template -->

    <!-- start section_b2_address_records_ccris_template -->
    <xsl:template name="section_b2_address_records_ccris_template">
        
        <xsl:if test="r:ccris_addresses/r:ccris_address">
            
            <xsl:for-each select="r:ccris_addresses/r:ccris_address">
                
                <tr>
                    <td>
                        <xsl:call-template name="check_empty_string">
                            <xsl:with-param name="value" select="."/>
                        </xsl:call-template>
                    </td>
                    <td class="text-center">
                        <xsl:call-template name="check_empty_string">
                            <xsl:with-param name="value" select="@date"/>
                        </xsl:call-template>
                    </td>
                    <td class="text-center">
                        BNM
                    </td>                                                
                </tr>
                
            </xsl:for-each>
            
        </xsl:if>
        
    </xsl:template>
    <!-- finish section_b2_address_records_ccris_template -->

</xsl:stylesheet>
