--Author : xumanli
return {
       ["lotto"]={
                               [1] = {
                                 ["need_diamond_num"]= 30,
                                 ["win_diamond_num_min"] = 33,
                                 ["win_diamond_num_max"] = 39
                                },

                                [2] = {
                                     ["need_diamond_num"]= 300,
                                     ["win_diamond_num_min"] = 324,
                                     ["win_diamond_num_max"] = 354
                                },

                                [3] = {
                                     ["need_diamond_num"]= 3000,
                                     ["win_diamond_num_min"] = 3150,
                                     ["win_diamond_num_max"] = 3450
                                },

                                [4] = {
                                     ["need_diamond_num"]= 30000,
                                     ["win_diamond_num_min"] = 31200,
                                     ["win_diamond_num_max"] = 34200
                                }
                    },

     ["RechargeRebate"]={
                                 [1] = {
                                             ["start_time"]= 20141222,
                                             ["save_days"] = 4,
					   					     ["delay_days"] = 0,
                                             ["return_days"] = 30,
                                             ["percentage"] = 0.035,
                                             ["max_values"] = 10000,
                                             ["min_values"] = 1000
                                        }
                          },       
                          
     ["ContinueRecharge"]={
                           [20141222] = {
                                          [1] = {
                                          			['type'] = 'Singlepen', --单笔充值   Singlepen 每日累计 CumulativeDaily  总累计Total 
								                    ['limit'] = {
								                        --完成条件
								                        ['pay money'] = '0.01',
								                    },
								                     	['mail'] = {
								                        --邮件内容
								                        ['title'] = 'Sufficient incentives',
								                        ['content'] =' ',
								                    },
								                    ['reward'] = {
								                        --获得奖励
								                        ['money'] = 2000,
								                        ['gem'] = 0,
								                        ['items'] = {
								                        	 ['386'] = 5,
                           									 ['218'] = 10,
                           									 ['471'] = 2,
								                         }
								                    }
								                },
                                        },
                                 [20141223] = {
                                              [1] = {
                                          			['type'] = 'Singlepen', --单笔充值
								                    ['limit'] = {
								                        --完成条件
								                        ['pay money'] = '4.99',
								                    },
								                   	['mail'] = {
								                        --完成条件
								                         ['title'] = 'Sufficient incentives',
								                      	 ['content'] =' ',
								                    },
								                    ['reward'] = {
								                        --获得奖励
								                        ['money'] = 5000,
								                        ['gem'] = 0,
								                        ['items'] = {
								                        	 ['386'] = 10,
                           									 ['471'] = 3, 
                           									 ['368'] = 10,
								                         }
								                    }
								                },
                                        },
                                  [20141224] = {
                                             [1] = {
                                          			['type'] = 'Singlepen', --单笔充值   Singlepen 每日累计 CumulativeDaily  总累计Total 
								                    ['limit'] = {
								                        --完成条件
								                        ['pay money'] = '9.99',
								                    },
								                     	['mail'] = {
								                        --完成条件
								                     	 ['title'] = 'Sufficient incentives',
								                      	 ['content'] =' ',
								                    },
								                    ['reward'] = {
								                        --获得奖励
								                        ['money'] = 6000,
								                        ['gem'] = 0,
								                        ['items'] = {
								                        	 ['386'] = 15,
                           									 ['471'] = 5, 
                           									 ['369'] = 6,
								                         }
								                    }
								                },
                                        },
                              [20141225] = {
                                            [1] = {
                                          			['type'] = 'Singlepen', --单笔充值
								                    ['limit'] = {
								                        --完成条件
								                        ['pay money'] = '19.99',
								                    },
								                     	['mail'] = {
								                        --完成条件
								                        ['title'] = 'Sufficient incentives',
								                      	['content'] =' ',
								                    },
								                    ['reward'] = {
								                        --获得奖励
								                        ['money'] = 8000,
								                        ['gem'] = 0,
								                         ['items'] = {
								                        	 ['386'] = 20,
                           									 ['471'] = 8, 
                           									 ['369'] = 10,
								                         }
								                    }
								                },
                                        },
                                [20141226] = {
                                         [1] = {
                                          			['type'] = 'Singlepen', --单笔充值
								                    ['limit'] = {
								                        --完成条件
								                        ['pay money'] = '49.99',
								                    },
								                     	['mail'] = {
								                        --完成条件
								                        ['title'] = 'Sufficient incentives',
								                      	['content'] =' ',
								                    },
								                    ['reward'] = {
								                        --获得奖励
								                        ['money'] = 10000,
								                        ['gem'] = 0,
								                       ['items'] = {
								                        	 ['386'] = 40,
                           									 ['471'] = 12, 
                           									 ['390'] = 30,
								                         }
								                    }
								                },
                                    },
                                      [20141227] = {
                                         [1] = {
                                          			['type'] = 'Singlepen', --单笔充值
								                    ['limit'] = {
								                        --完成条件
								                        ['pay money'] = '99.99',
								                    },
								                     	['mail'] = {
								                        --完成条件
								                       ['title'] = 'Sufficient incentives',
								                      	['content'] =' ',
								                    },
								                    ['reward'] = {
								                        --获得奖励
								                        ['money'] = 20000,
								                        ['gem'] = 0,
								                       ['items'] = {
								                        	 ['386'] = 45,
                           									 ['471'] = 20, 
                           									 ['390'] = 60,
								                         }
								                    }
								                },
                                    },
                                      [20141228] = {
                                         [1] = {
                                          			['type'] = 'Singlepen', --单笔充值
								                    ['limit'] = {
								                        --完成条件
								                        ['pay money'] = '99.99',
								                    },
								                     	['mail'] = {
								                        --完成条件
								                       ['title'] = 'Sufficient incentives',
								                      	['content'] =' ',
								                    },
								                    ['reward'] = {
								                        --获得奖励
								                        ['money'] = 20000,
								                        ['gem'] = 0,
								                       ['items'] = {
								                        	 ['386'] = 45,
                           									 ['471'] = 20, 
                           									 ['370'] = 10,
								                         }
								                    }
								                },
                                    },
                        },

    ["ChristmasGift"]={
	  [1] = {
                    ["Reward ID"] = 599,
                    ["Reward Weight"] = 22,
                    ["Reward Amount"] = 3000,        
                    ["Reward Type"] = "money",
		    ["Reward TypeStatus"] =2
                },
                [2] = {
                    ["Reward ID"] = 599,
                    ["Reward Weight"] = 16,
                    ["Reward Amount"] = 5000,
                    ["Reward Type"] = "money",
		    ["Reward TypeStatus"] =2	                   
                },
                [3] = {
                    ["Reward ID"] = 599,
                    ["Reward Weight"] = 12,
                    ["Reward Amount"] = 8000,
                    ["Reward Type"] = "money",
		    ["Reward TypeStatus"] =2	
                },
                [4] = {
                    ["Reward ID"] = 229,
                    ["Reward Weight"] = 6,
                    ["Reward Amount"] = 2,
                    ["Reward Type"] = "item",
		    ["Reward TypeStatus"] =3	
                },
                [5] = {
                    ["Reward ID"] = 231,
                    ["Reward Weight"] = 6,
                    ["Reward Amount"] = 2,
                    ["Reward Type"] = "item",
		    ["Reward TypeStatus"] =3	
                },
                [6] = {
                    ["Reward ID"] = 221,
                    ["Reward Weight"] = 6,
                    ["Reward Amount"] = 2,
                    ["Reward Type"] = "item",
		   			 ["Reward TypeStatus"] =3
                },
                [7] = {
                    ["Reward ID"] = 219,
                    ["Reward Weight"] = 6,
                    ["Reward Amount"] = 2,
                    ["Reward Type"] = "item",
		  		  ["Reward TypeStatus"] =3	
                },
                [8] = {
                    ["Reward ID"] = 224,
                    ["Reward Weight"] = 6,
                    ["Reward Amount"] = 2,
                    ["Reward Type"] = "item",
		    ["Reward TypeStatus"] =3	
                },
                [9] = {
                    ["Reward ID"] = 253,
                    ["Reward Weight"] = 6,
                    ["Reward Amount"] = 2,
                    ["Reward Type"] = "item",
		    ["Reward TypeStatus"] =3	
                },
                [10] = {
                    ["Reward ID"] = 247,
                    ["Reward Weight"] = 2,
                    ["Reward Amount"] = 2,
                    ["Reward Type"] = "item",
		    ["Reward TypeStatus"] =3
                },
                [11] = {
                    ["Reward ID"] = 261,
                    ["Reward Weight"] = 2,
                    ["Reward Amount"] = 2,
                    ["Reward Type"] = "item",
		    ["Reward TypeStatus"] =3	
                },
                [12] = {
                    ["Reward ID"] = 262,
                    ["Reward Weight"] = 2,
                    ["Reward Amount"] = 2,
                    ["Reward Type"] = "item",
		    ["Reward TypeStatus"] =3
                },
                [13] = {
                    ["Reward ID"] = 258,
                    ["Reward Weight"] = 2,
                    ["Reward Amount"] = 2,
                    ["Reward Type"] = "item",
		    ["Reward TypeStatus"] =3	
                },
                [14] = {
                    ["Reward ID"] = 250,
                    ["Reward Weight"] = 2,
                    ["Reward Amount"] = 2,
                    ["Reward Type"] = "item",
		    ["Reward TypeStatus"] =3	
                },
                [15] = {
                    ["Reward ID"] = 257,
                    ["Reward Weight"] = 2,
                    ["Reward Amount"] = 2,
                    ["Reward Type"] = "item",
		    ["Reward TypeStatus"] =3
                },
                [16] = {
                    ["Reward ID"] = 138,
                    ["Reward Weight"] = 2,
                    ["Reward Amount"] = 2,
                    ["Reward Type"] = "item",
		    ["Reward TypeStatus"] =3	
                },
                [17] = {
                    ["Reward ID"] = 128,
                    ["Reward Weight"] = 2,
                    ["Reward Amount"] = 2,
                    ["Reward Type"] = "item",
		    ["Reward TypeStatus"] =3	
                },
                [18] = {
                    ["Reward ID"] = 145,
                    ["Reward Weight"] = 2,
                    ["Reward Amount"] = 2,
                    ["Reward Type"] = "item",
		    ["Reward TypeStatus"] =3	
                }
    },
    ["ChristmasGiftReset"]={
	    [1] = 20,
	    [2] =40,
	    [3] =60,
	    [4] =80,
	    [5]=100,
	    [6]=200,
	    [7]=300,
	    ['common']=500	
    },
   ["ChristmasMailReward"]={
   			['version'] = '20141222',
			['rewardTime'] = '20141229', --发奖日期
			['rankLimit'] = 20, --奖励排名最大值
			['reward']={
				[1]={
					['mail'] = {
						['title']='Rankings reward',
						['content']=' ',
					},
					['money'] = 1000000,
					['gem'] = 0,
					['items'] = {
                        	 ['379'] = 80,
							 ['370'] = 20,
                         }
				},
				[2]={
					['mail'] = {
						['title']='Rankings reward',
						['content']=' ',
					},
					['money'] = 500000,
					['gem'] = 0,
					['items'] = {
                        	 ['379'] = 30,
							 ['369'] = 30,
                         }
				},
				[5]={
					['mail'] = {
						['title']='Rankings reward',
						['content']=' ',
					},
					['money'] = 200000,
					['gem'] = 0,
					['items'] = {
                        	 ['379'] = 20,
							 ['368'] = 30,
                         }
				},
				[10]={
					['mail'] = {
						['title']='Rankings reward',
						['content']=' ',
					},
					['money'] = 100000,
					['gem'] = 0,
					['items'] = {
                        	 ['379'] = 10,
							 ['368'] = 20,
                         }
				},
				[20]={
					['mail'] = {
						['title']='Rankings reward',
						['content']=' ',
					},
					['money'] = 100000,
					['gem'] = 0,
					['items'] = {
                        	 ['379'] = 5,
                         }
				}
			}
    }
}
