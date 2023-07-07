describe 'test set name'
  before
    BeforeCommand
  end

  after
    AfterCommand
  end

  it 'test name'
    Expect 1 == 1
  end

  context 'context name'
    it 'context test name'
      Expect 2 == 2
    end
  end
end
